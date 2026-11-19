"""Seeded route geometry and time scheduling for the nine-shark loop."""
import numpy as np
from scipy.interpolate import CubicSpline

def routes(rng, count, samples):
    q = np.linspace(0, 2*np.pi, 1201)
    routes = []
    for i in range(count):
        # Long diagonals pass through different parts of the middle, with gently
        # bent crossovers and wide turning lobes at opposite ends of the window.
        slope = (-.32,-.10,.21,.31,-.24,.12,.27,-.17,.05)[i]
        span = (380,409,398,420,392,400,426,408,403)[i]
        lobe = (98,139,115,128,145,122,103,122,136)[i]
        sense = (-1,1,1,-1,1,-1,1,-1,1)[i]
        x = span*np.sin(q) + (27+3*i)*np.sin(2*q+.3*i)
        y = slope*x + sense*lobe*np.sin(2*q) + 31*np.sin(q+.83*i)**3
        source = np.c_[580+x+36*np.sin(i*2.4),355+y+48*np.cos(i*2.4)]
        source[-1] = source[0]
        arc = np.r_[0,np.linalg.norm(np.diff(source,axis=0),axis=1).cumsum()]
        curve = CubicSpline(arc/arc[-1],source,bc_type='periodic')
        u = np.arange(samples)/samples
        progress = u + .48/(4*np.pi)*np.sin(4*np.pi*u)
        if i%2 == 0:
            progress = -progress
        routes.append(curve((progress+rng.uniform(-.015,.015))%1))
    return np.array(routes)

def schedule(paths, scales, rng):
    count, frames, _ = paths.shape
    stride = 16
    coarse = paths[:,::stride]
    ticks = coarse.shape[1]
    velocity = np.roll(coarse,-1,axis=1)-np.roll(coarse,1,axis=1)
    unit = velocity/np.maximum(np.linalg.norm(velocity,axis=2,keepdims=True),1e-5)
    costs = np.zeros((count,count,ticks))
    for i in range(count):
        for j in range(i+1,count):
            offsets = (np.arange(ticks)[:,None]+np.arange(ticks))%ticks
            delta = coarse[i,None,:,:]-coarse[j,offsets]
            distance = np.linalg.norm(delta,axis=2)
            axis = delta/np.maximum(distance[:,:,None],1)
            along_a = np.sum(axis*unit[i],axis=2)
            along_b = np.sum(axis*unit[j,offsets],axis=2)
            support_a = scales[i]*np.sqrt(40**2+(78**2-40**2)*along_a**2)
            support_b = scales[j]*np.sqrt(40**2+(78**2-40**2)*along_b**2)
            deficit = np.maximum(0,support_a+support_b+15-distance)
            costs[i,j] = np.sum(deficit**2,axis=1)
            costs[j,i] = costs[i,j,(-np.arange(ticks))%ticks]
    indices = np.arange(ticks)
    best = (np.inf,None)
    for _ in range(96):
        phases = rng.integers(ticks,size=count)
        for _ in range(14):
            for i in rng.permutation(count):
                choices = costs[i,np.arange(count)[:,None],(phases[:,None]-indices)%ticks].sum(axis=0)
                phases[i] = choices.argmin()
        cost = sum(costs[i,j,(phases[j]-phases[i])%ticks] for i in range(count) for j in range(i+1,count))
        if cost < best[0]:
            best = (cost,phases.copy())
    return np.array([np.roll(path,-int(phase)*stride,axis=0) for path,phase in zip(paths,best[1])])


def dash_after_passing(paths, low, high, fps):
    """Apply a smooth local phase advance, only with room ahead after a pass."""
    count, frames, _ = paths.shape
    samples = np.arange(frames)
    times = samples/fps
    proposed = paths.copy()
    events = []
    for i, path in enumerate(paths):
        peers = np.arange(count) != i
        gap = np.maximum(low[i]-high[peers],low[peers]-high[i]).max(axis=2).min(axis=0)
        speed = np.linalg.norm(np.roll(path,-1,axis=0)-np.roll(path,1,axis=0),axis=1)*fps/2
        # A previous close pass must have opened up before accelerating.
        for k in np.argsort(gap)[::2]:
            if gap[k]>40:
                break
            for wait in (1.75,2.25,2.75,3.25):
                start = (k+int(wait*fps))%frames
                look = (start+np.arange(int(1.35*fps)))%frames
                if gap[look].min()<45 or not 23<speed[start]<65:
                    continue
                peak = (start+1.3*fps)%frames
                if any(abs((peak-(t+1.3)*fps+frames/2)%frames-frames/2)<2.4*fps for _,t in events):
                    continue
                offset=(samples-peak+frames/2)%frames-frames/2
                advance=.56*fps*np.exp(-.5*(offset/(1.30*fps))**2)
                query=samples+advance
                left=query.astype(int)
                alpha=(query-left)[:,None]
                warped=path[left%frames]*(1-alpha)+path[(left+1)%frames]*alpha
                # Reject any advance that erodes the baseline projected gap.
                source_idx=np.round(query).astype(int)%frames
                low_advance = low[i,source_idx]
                high_advance = high[i,source_idx]
                forecast = np.maximum(low_advance-high[peers],low[peers]-high_advance).max(axis=2).min(axis=0)
                affected = advance>.025*fps
                if np.min(forecast[affected]-np.minimum(gap[affected],18)) < -2:
                    continue
                proposed[i] = warped
                events.append((i,round(float(times[start]),2)))
                break
            else:
                continue
            break
    if not events:
        raise RuntimeError('No open-water dash candidate')
    return proposed, events
