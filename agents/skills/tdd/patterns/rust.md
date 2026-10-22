# Rust Tests

Rules for writing reliable, maintainable Rust tests. Prefer Rust's type system and standard testing framework. Add dependencies only when they provide capabilities that Rust does not already offer.

## 1. Test Public Contracts at the Crate Boundary

Use two test locations for different purposes.

- **`src/` with `#[cfg(test)]`:** Test private invariants and implementation-specific behavior when necessary.
- **`tests/`:** Test the crate through its public API, as an external consumer would.

```rust
// src/task.rs
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn normalizes_title() {
        assert_eq!(normalize_title("  Hello  "), "Hello");
    }
}
```

Prefer integration tests for stable public behavior. Do not make private functions `pub` only to test them.

Remember that integration tests compile your library without its `#[cfg(test)]` items.

## 2. Do Not Test Guarantees Already Enforced by the Compiler

Rust's compiler verifies ownership, borrowing, types, and trait constraints.

Do not write runtime tests for properties that cannot be violated by a successfully compiled program.

**Test runtime invariants instead:**

- A validated type rejects invalid external data.
- A state transition preserves domain invariants.
- An operation does not leave partially modified state after failure.
- A serializer preserves information across round trips.

When compile-time rejection is itself part of your public API contract, use `compile_fail` documentation tests or `trybuild`.

## 3. Assert Typed Errors, Not Error Messages

Prefer checking error variants using `matches!`.

```rust
#[test]
fn rejects_empty_title() {
    let result = Task::try_new("");

    assert!(matches!(
        result,
        Err(TaskError::EmptyTitle)
    ));
}
```

Avoid:

```rust
assert_eq!(
    result.unwrap_err().to_string(),
    "Title cannot be empty"
);
```

Error messages can change without changing behavior. Assert message text only when the message itself is a documented contract.

## 4. Use `Result` for Fallible Test Setup

Tests may return `Result<(), E>`.

```rust
#[test]
fn loads_valid_configuration() -> Result<(), Box<dyn std::error::Error>> {
    let config = load_fixture("valid.toml")?;
    let parsed = Config::parse(&config)?;

    assert_eq!(parsed.port, 8080);
    Ok(())
}
```

Use `?` for setup failures and unexpected errors.

Use `expect("reason")` when failure context matters.

Do not discard a `Result` to make a test pass. For expected failures, assert the specific error.

## 5. Compare Values, Not Their Debug Representations

Prefer `assert_eq!` for types with meaningful `PartialEq` implementations.

```rust
assert_eq!(actual, expected);
```

Avoid:

```rust
assert_eq!(
    format!("{actual:?}"),
    format!("{expected:?}")
);
```

Debug output is not a behavioral contract.

Derive `Debug` and `PartialEq` when their semantics are appropriate. Do not add artificial equality semantics to production types solely for test convenience.

## 6. Mock Traits Only at Real Dependency Boundaries

Rust does not need a trait for every struct.

Introduce a trait when it represents a meaningful interchangeable dependency, such as an HTTP client, clock, or external service.

```rust
trait Clock {
    fn now(&self) -> SystemTime;
}

struct FixedClock(SystemTime);

impl Clock for FixedClock {
    fn now(&self) -> SystemTime {
        self.0
    }
}
```

Prefer small handwritten fakes for simple dependencies. Use Mockall when call expectations or complicated interactions justify it.

**Never mock the business logic you intend to test.**

Do not change a concrete implementation into a complex generic hierarchy just to make mocking easier.

## 7. Test SQL with a Real Database Engine

Mock repositories in service unit tests when database behavior is irrelevant.

Do not mock SQL execution when testing a repository.

For `rusqlite`:

- Use `Connection::open_in_memory()` for isolated query tests.
- Use temporary file-backed databases for WAL, locking, checkpoint, and multi-connection behavior.
- Execute actual migrations when testing schema compatibility.
- Verify constraints and transaction behavior using SQLite itself.

A mocked database cannot establish that your SQL is valid.

## 8. Make Fixtures Own Their Resources

Rust's ownership model makes fixture lifetimes important.

Prefer fixtures that own their temporary resources.

```rust
struct DbFixture {
    _temp_dir: tempfile::TempDir,
    connection: rusqlite::Connection,
}
```

The temporary directory remains alive for the fixture's lifetime.

Avoid `Box::leak`, global references, and complicated lifetime parameters just to share test resources.

Prefer creating a new fixture per test over resetting a shared fixture.

## 9. Treat Async Tests as Concurrency Tests Only When Appropriate

Use `#[tokio::test]` for code requiring Tokio.

The default Tokio test runtime is single-threaded. Use the multi-thread runtime when verifying behavior that depends on concurrent thread scheduling.

```rust
#[tokio::test(flavor = "multi_thread", worker_threads = 2)]
async fn processes_concurrent_jobs() {
    // Exercise shared state through concurrent tasks.
}
```

Do not assume `tokio::spawn` means a task has completed.

Await spawned task handles and inspect their results.

Avoid holding a `std::sync::MutexGuard` across `.await`. Prefer explicit synchronization and minimize shared mutable test state.

## 10. Never Use Arbitrary Sleeps for Synchronization

Avoid:

```rust
tokio::spawn(process_job());
tokio::time::sleep(Duration::from_millis(100)).await;
assert!(job_completed());
```

The delay does not guarantee completion.

Prefer:

- Awaiting `JoinHandle`.
- `tokio::sync::oneshot` for completion signals.
- `Barrier` for controlled concurrency.
- Paused Tokio time for timer-driven logic.
- Explicit timeouts to detect hung operations.

Test logical ordering using synchronization, not assumptions about scheduler timing.

## 11. Verify State After Errors

Rust's `Result` distinguishes failure from success. It does not guarantee that a failed operation preserved the previous state.

```rust
#[test]
fn failed_withdrawal_preserves_balance() {
    let mut account = Account::new(100);

    let result = account.withdraw(200);

    assert!(matches!(
        result,
        Err(AccountError::InsufficientFunds)
    ));

    assert_eq!(account.balance(), 100);
}
```

For stateful Rust services, test both the returned error and the resulting state.

Pay special attention to database transactions, file writes, and operations involving multiple resources.

## 12. Avoid Process-Global Test State

Rust tests run in parallel by default.

Avoid tests that mutate shared process state:

- Environment variables.
- Current working directory.
- Global mutable statics.
- Shared database files.
- Fixed TCP ports.

Inject configuration into the system under test instead.

In Rust 2024, mutating process environment variables is unsafe because it can conflict with concurrent access.

Do not disable parallel execution globally to compensate for poor isolation.

## 13. Use Property-Based Tests for General Invariants

Use `proptest` when correctness can be expressed as a property rather than a fixed collection of examples.

```rust
proptest! {
    #[test]
    fn normalization_is_idempotent(input in any::<String>()) {
        let once = normalize(&input);
        let twice = normalize(&once);

        prop_assert_eq!(once, twice);
    }
}
```

Good targets include parsers, encoders, normalization, serialization, and algorithms with mathematical invariants.

Keep explicit regression tests for previously discovered failures, even when property-based tests cover the same domain.

## 14. Reserve Panic Tests for Intentional Panics

Use `#[should_panic]` only when panicking is part of the function's intended contract.

Do not test recoverable validation errors using panic assertions.

Prefer typed `Result` errors for expected failure conditions.

Avoid `catch_unwind` merely to test ordinary business logic.

## 15. Keep Test-Only Code Out of Production Paths

Put unit-test helpers inside `#[cfg(test)]` modules.

Put integration-test fixtures under `tests/common/` or a dedicated test-support crate when several crates genuinely need them.

Do not add production branches such as:

```rust
if cfg!(test) {
    return fake_response();
}
```

Production logic and test logic should not have different behavior solely because the test configuration is active.

Test dependencies should not leak into production dependencies unless the production code actually requires them.

## 16. Test Rust Libraries Below Framework Adapters

For applications with a framework layer, keep most behavior tests inside ordinary Rust crates.

For example:

```text
domain crate       → invariants and state transitions
service crate      → orchestration and failure behavior
database crate     → real SQL and migrations
Tauri adapter      → command argument/result contracts
application E2E    → complete user workflows
```

Do not require a running Tauri application to test business rules that can execute as ordinary Rust functions.

Keep adapter-specific tests focused on serialization, argument conversion, error mapping, permissions, and framework integration.

## 17. Make Every Test Failure Diagnostic

A failing test must make the violated contract identifiable.

Prefer:

```rust
assert_eq!(task.status, Status::Completed);
```

Over:

```rust
assert!(task.status != Status::Pending);
```

Avoid unnecessary assertions, but verify enough of the result to reject incorrect behavior.

A successful test must establish a meaningful property of the system, not merely demonstrate that the code executed without panicking.
