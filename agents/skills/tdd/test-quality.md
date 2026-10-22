# Test quality

## Behavior and independent expectations

Name the capability and condition. Arrange realistic inputs, act through the selected seam, and assert the promised result. Several assertions are useful when they establish one behavior; assertion count is not a quality measure.

```typescript
// Expected value repeats the algorithm under test.
const expected = items.reduce((sum, item) => sum + item.price, 0);
expect(calculateTotal(items)).toBe(expected);

// A worked example supplies an independent oracle.
expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
```

Assert meaningful values, errors, durable state or side effects. A broad success check can miss the wrong successful result. Select fields that express the contract; whole-object equality is useful when the entire object is promised.

## Doubles and real dependencies

Choose the setup according to what the test must prove, subject to project policy:

- Exercise the real behavior under test.
- Use small fakes or controlled responses for dependencies outside that behavior.
- Use real temporary storage when persistence, transactions or filesystem semantics are the assertion.
- Use real processes when launch, protocol or termination behavior is the assertion.

Whether your team owns a dependency does not determine whether to fake it. Keep dependency interfaces meaningful; avoid architecture changes solely to enable mocking.

Observe effects through the selected interfaces. For example, create an item and retrieve it through the application API to establish persistence. Direct database inspection belongs where stored representation is itself the selected contract.

```typescript
test("created task is retrievable", async () => {
  const tasks = await createTestTaskService(); // Isolated real storage.
  try {
    const created = await tasks.create({ title: "Buy milk" });
    const retrieved = await tasks.get(created.id);

    expect(retrieved).toMatchObject({
      id: created.id,
      title: "Buy milk",
      status: "pending",
    });
  } finally {
    await tasks.close();
  }
});
```

Here `createTestTaskService` represents a project fixture using the actual persistence implementation. Reading back the generated ID checks identity; the literal title and status independently check the saved behavior.

Call arguments or counts are useful when an interaction is the promised effect, such as sending one notification. Asserting an internal helper's call order couples the test to implementation. Calling a mock directly and asserting its configured response exercises no application behavior.

## Isolation and completion

Give tests independent state and deterministic fixtures. Control time, randomness and external responses when they affect the outcome. Await completion and observe background failures. Use bounded completion signals instead of sleeps that guess when work finishes.

Keep fixtures faithful to actual contracts and setup proportionate to the selected risk. Existing project fixtures and nearby representative tests are the starting point; additional harness machinery must earn its complexity.
