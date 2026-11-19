"""Seeded open-water plan and fixed-length articulated ASCII swimmer bake."""
import json, subprocess
from pathlib import Path
import cv2
import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from scipy.ndimage import gaussian_filter1d
from svgpathtools import parse_path
from cross_plan import routes, schedule, dash_after_passing

HERE = Path(__file__).parent
W, H, FPS, SECONDS = 744, 455, 40, 56
N = FPS * SECONDS
DT = 1/FPS
DIMS = np.array([1160.,710.])
SCALE = W/1160
FISH_SCALE = np.array([1.47,1.132,1.323,.882,1.205,.956,1.55,1.65,1.75])
COUNT = len(FISH_SCALE)
RL = 130.
TURN_CAP, ACCEL_CAP, SPEED_CAP = 1.7, 125., 113.
OUT = HERE/'shark-crossing.webp'

def central(a, steps=1):
    return (np.roll(a,-steps,axis=1)-np.roll(a,steps,axis=1))/(2*steps*DT)

def plan(seed):
    rng = np.random.default_rng(seed)
    source = schedule(routes(rng, COUNT, N), FISH_SCALE, rng)
    paths=source.copy()
    # Shared periodic solve. Closest-approach lookahead steers early.
    # Walls and the hard pair certificate take priority over preferred routes.
    for _ in range(100):
        vel=central(paths,20)
        forward=vel/np.maximum(np.linalg.norm(vel,axis=2)[:,:,None],1e-8)
        normal=np.stack((-forward[:,:,1],forward[:,:,0]),axis=2)
        adjustment=np.zeros_like(paths)
        for i in range(COUNT):
            along=forward[i]
            side=normal[i]
            edge=FISH_SCALE[i]*np.hypot(along*78,side*40)+16
            look=paths[i]+vel[i]*1.5
            safe=np.clip(look,edge+30,DIMS-edge-23)
            adjustment[i]+=(safe-look)*.09
            adjustment[i]+=(np.clip(paths[i],edge,DIMS-edge)-paths[i])*.45
            for j in range(i+1,COUNT):
                delta=paths[i]-paths[j]
                rel=vel[i]-vel[j]
                ahead=np.clip(-np.sum(delta*rel,axis=1)/np.maximum(np.sum(rel*rel,axis=1),1),0,1.8)
                predicted=delta+rel*ahead[:,None]
                axis0=delta/np.maximum(np.linalg.norm(delta,axis=1)[:,None],1e-8)
                axes=np.stack((axis0,side,normal[j]))
                projected=np.sum(axes*delta,axis=2)
                axes=np.where(projected[:,:,None]<0,-axes,axes)
                def support(k):
                    along=np.sum(axes*forward[k],axis=2)
                    side=np.sum(axes*normal[k],axis=2)
                    return FISH_SCALE[k]*np.hypot(along*81,side*41)
                required=support(i)+support(j)+16
                gaps=abs(projected)-required
                best=gaps.argmax(axis=0)
                samples=np.arange(N)
                axis=axes[best,samples]
                actual=gaps[best,samples]
                future=np.sum(predicted*axis,axis=1)-required[best,samples]
                strength=np.maximum(0,14-actual)*.29+np.maximum(0,15-future)*.045
                force=axis*strength[:,None]
                adjustment[i]+=force
                adjustment[j]-=force
        paths+=gaussian_filter1d(adjustment,FPS*1.04,axis=1,mode='wrap')+.012*(source-paths)
    return np.round(gaussian_filter1d(paths,FPS*np.hypot(.88,1),axis=1,mode='wrap'),4)

def certify(paths):
    following=np.roll(paths,-1,axis=1)
    chord=(following-paths)/DT
    velocity=central(paths,8)
    heading=np.arctan2(velocity[:,:,1],velocity[:,:,0])
    step_yaw=np.angle(np.exp(1j*(np.roll(heading,-1,axis=1)-heading)))
    speed=float(np.max(np.linalg.norm(chord,axis=2)))
    turn=float(np.max(abs(step_yaw))/DT)
    accel=float(np.max(np.linalg.norm(np.roll(chord,-1,axis=1)-chord,axis=2))/DT)
    zones=[len(set(zip((p[:,0]//(1160/3)).astype(int),(p[:,1]//355).astype(int)))) for p in paths]
    metrics=dict(maxSpeed=speed,maxYawRate=turn,maxChordAcceleration=accel,zones=zones)
    valid=speed<SPEED_CAP and turn<TURN_CAP and accel<ACCEL_CAP and min(zones)>=3
    return valid,metrics,heading,step_yaw,np.linalg.norm(velocity,axis=2)

# The existing corrected shark silhouette, expressed in one rest pose.
OUTLINE='M 52 0 C 52 -5 31 -12 15 -14 C -7 -16 -26 -9 -43 -5 Q -54 -3 -62 -2 L -62 2 Q -54 3 -43 5 C -26 9 -7 16 15 14 C 31 12 52 5 52 0 Z'
FINS=['M 13 -10 C 7 -17 -7 -31 -23 -35 Q -21 -28 -15 -21 Q -13 -17 -12 -12 Z',
      'M 13 10 C 7 17 -7 31 -23 35 Q -21 28 -15 21 Q -13 17 -12 12 Z']
TAIL='M -53 -2.4 Q -64 -3 -77 -15 Q -76 -8 -70 -1 Q -69 0 -71 2 Q -75 7 -76 12 Q -61 3 -53 2.4 Z'
RIDGE='M 11 -1 Q -2 -2 -12 0 Q -2 2 11 1 Z'
LIGHT='M 43 -2 Q 31 -11 12 -8 Q 25 -1 43 -2 Z'

def poly(d):
    p=parse_path(d)
    z=np.array([seg.point(t) for seg in p for t in np.linspace(0,1,13,endpoint=False)]+[p[-1].end])
    return np.c_[z.real,z.imag]

def rotate(v,a):
    c,s=np.cos(a),np.sin(a)
    return np.stack((v[...,0]*c-v[...,1]*s,v[...,0]*s+v[...,1]*c),axis=-1)

BODY, PECT, CAUDAL, BACK, SHINE = poly(OUTLINE), list(map(poly,FINS)),poly(TAIL),poly(RIDGE),poly(LIGHT)
xs=np.linspace(52,-62,13)
ell=xs[:-1]-xs[1:]
s=52-xs
u=s/RL
front=np.clip((u-.20)/.10,0,1)
E=u**2.5*front**2*(3-2*front)
weights=np.maximum(0,(u[1:]+u[:-1])*.5-.30)**1.2
weights/=weights.sum()
bend_weights=weights.cumsum()-.5*weights

def mesh(angle,phase,amplitude,bend):
    wave=amplitude*E*np.sin(2*np.pi*(phase-u/1.25))
    yaw=np.arcsin(np.clip(np.diff(wave)/ell,-.95,.95))+bend*bend_weights
    angles=angle+np.pi-yaw
    links=ell[:,None]*np.c_[np.cos(angles),np.sin(angles)]
    joints=np.vstack(([0,0],links.cumsum(axis=0)))
    return joints, angles, float(np.max(abs(np.linalg.norm(np.diff(joints,axis=0),axis=1)-ell)))

def mapped(poly,joints,angles,attachment=None):
    q=52-poly[:,0]
    if attachment is not None: q=np.full(len(poly),52-attachment)
    j=np.clip(np.searchsorted(s,q,side='right')-1,0,len(ell)-1)
    # Adjacent segment-frame interpolation yields a continuous skin at joints.
    # Rigid fins share the exact center and frame at their attachment.
    along=(q-s[j])
    loc=joints[j]+rotate(np.c_[along,np.zeros(len(j))],angles[j])
    angle0=np.unwrap(angles)
    center=(s[:-1]+s[1:])*.5
    angles_at=np.interp(q,center,angle0)
    local=np.c_[52-poly[:,0]-q,-poly[:,1]]
    return loc+rotate(local,angles_at)

def glyph_grid():
    img=Image.new('L',(W,H))
    draw=ImageDraw.Draw(img)
    font=ImageFont.truetype('/System/Library/Fonts/Menlo.ttc',6)
    chars=sorted(':.+-=ox*#%@~;<>01/|',key=lambda x:sum(font.getmask(x)))
    rng=np.random.default_rng(2526)
    for y in range(-3,H,4):
        for x in range(0,W,4):
            draw.text((x,y),rng.choice(chars),font=font,fill=int(rng.integers(160,250)))
    return np.asarray(img)

def poses(paths, heading, yaw, speed):
    v=speed/(RL*FISH_SCALE[:,None])
    speed_table=[0,.2,.4,.8,1.3,2.]
    freq=np.interp(v,speed_table,[.3,.55,.85,1.45,1.9,2.4])
    # Spread sub-cycle rounding uniformly. Continual integration preserves dash phase.
    freq+=(np.rint(freq.sum(axis=1)*DT)-freq.sum(axis=1)*DT)[:,None]/SECONDS
    phase=np.c_[np.zeros(COUNT),np.cumsum(freq[:,:-1]*DT,axis=1)]+np.arange(COUNT)[:,None]*.173
    amp=gaussian_filter1d(np.interp(v,speed_table,[.10,.15,.17,.18,.19,.2])*RL*.5,FPS*.23,axis=1,mode='wrap')
    bend=np.clip(.75*RL*yaw/DT/np.maximum(speed/FISH_SCALE[:,None],.5*RL),-.45,.45)
    bend=gaussian_filter1d(bend,FPS*.17,axis=1,mode='wrap')
    polygons = [PECT[0], PECT[1], CAUDAL, BODY, BACK, SHINE]
    anchors = [1, 1, -57, None, None, None]
    points = [np.empty((COUNT,N,len(polygon),2)) for polygon in polygons]
    link_error = 0.
    for i, scale in enumerate(FISH_SCALE):
        for k, h in enumerate(heading[i]):
            joints, angles, error = mesh(h,phase[i,k],amp[i,k],bend[i,k])
            link_error = max(link_error,error)
            nose = paths[i,k]+52*scale*np.array([np.cos(h),np.sin(h)])
            for output, polygon, anchor in zip(points, polygons, anchors):
                output[i,k] = nose+scale*mapped(polygon,joints,angles,anchor)
    return points, link_error, np.rint(freq.sum(axis=1)*DT).astype(int).tolist()


def projected_bounds(points):
    # A single fixed separating axis must work at both ends of each frame interval.
    silhouette = np.concatenate(points,axis=2)
    edge = float(np.min(np.minimum(silhouette,DIMS-silhouette)))
    angles = np.arange(36)*np.pi/36
    axes = np.stack((np.cos(angles),np.sin(angles)))
    low = np.empty((COUNT,N,len(angles)))
    high = np.empty_like(low)
    for i,shark in enumerate(silhouette):
        projected = shark @ axes
        low[i] = projected.min(axis=1)
        high[i] = projected.max(axis=1)
    return edge, low, high


def clearance(points):
    edge, low, high = projected_bounds(points)
    separation = float('inf')
    for i in range(COUNT):
        for j in range(i+1,COUNT):
            gap = np.concatenate((low[i]-high[j], low[j]-high[i]),axis=1)
            stable = np.minimum(gap,np.roll(gap,-1,axis=0)).max(axis=1)
            separation = min(separation,float(stable.min()))
    return dict(edgeClearance=edge,pairClearance=separation)


def run():
    cv2.setNumThreads(2)
    for seed in [51,431,25119,2526]:
        paths = plan(seed)
        valid, metrics, heading, yaw, speed = certify(paths)
        if valid:
            points, link_error, phase_turns = poses(paths,heading,yaw,speed)
            metrics.update(clearance(points))
            if metrics['edgeClearance']>3 and metrics['pairClearance']>3:
                print(seed,metrics,flush=True)
                break
        print(seed,metrics,flush=True)
    else:
        raise RuntimeError('No seed satisfied steering certificate')
    _, low, high = projected_bounds(points)
    dashed, dash_times = dash_after_passing(paths, low, high, FPS)
    for factor in (1., .75, .5):
        candidate = np.round(paths+(dashed-paths)*factor,4)
        valid, candidate_metrics, heading, yaw, speed = certify(candidate)
        if not valid:
            continue
        candidate_points, error, turns = poses(candidate,heading,yaw,speed)
        candidate_metrics.update(clearance(candidate_points))
        if candidate_metrics['edgeClearance']>3 and candidate_metrics['pairClearance']>3:
            paths, points, link_error, phase_turns = candidate, candidate_points, error, turns
            metrics = {**candidate_metrics, 'dashSeconds':dash_times, 'dashFactor':factor}
            print(metrics,flush=True)
            break
    else:
        raise RuntimeError('Dash proposals did not pass the playback certificate')
    np.save(HERE/'crossing-paths.npy', paths)
    (HERE/'crossing-paths-metadata.json').write_text(json.dumps(metrics,indent=2))
    grid=glyph_grid()
    colors=np.zeros((H,W,4),dtype=np.uint8)
    colors[:,:,:3]=(188,185,215)
    ff=imageio_ffmpeg.get_ffmpeg_exe()
    enc=subprocess.Popen([ff,'-hide_banner','-loglevel','error','-y','-f','rawvideo','-pixel_format','rgba','-video_size',f'{W}x{H}','-framerate',str(FPS),'-i','pipe:0','-c:v','libwebp_anim','-lossless','1','-quality','85','-compression_level','6','-loop','0',str(OUT)],stdin=subprocess.PIPE)
    assert link_error<1e-9,link_error
    for k in range(N):
        mask=np.zeros((H,W),np.uint8)
        for i in range(COUNT):
            for polygon,value in zip(points,(100,100,115,160,145,180)):
                raster = np.rint(polygon[i,k]*SCALE*16).astype(np.int32)
                cv2.fillPoly(mask,[raster],value,cv2.LINE_AA,shift=4)
        colors[:,:,3]=(((mask.astype(np.uint16)*grid//255+12)//24)*24).astype(np.uint8)
        enc.stdin.write(colors.tobytes())
        if k%400==0: print(f'Rendered {k}/{N}',flush=True)
    enc.stdin.close()
    if enc.wait()!=0: raise RuntimeError('Encoding failed')
    assert OUT.stat().st_size<16_000_000,OUT.stat().st_size
    np.save(HERE/'crossing-paths.npy', paths)
    result={**metrics,'seed':seed,'frames':N,'fps':FPS,'loopSeconds':SECONDS,'maxJointError':link_error,'bytes':OUT.stat().st_size,'phaseTurns':phase_turns}
    (HERE/'crossing-verification.json').write_text(json.dumps(result,indent=2))
    print(result,flush=True)

if __name__=='__main__':
    run()
