#Rachel's Children
# Eli...

use_bpm 60

tracker = [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]
volume =  [0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0]
set_volume! 5

n = (ring :r, :r, :d2, :d3, :f3, :r, :d1, :f2)

fade_in = (line 0, 2, inclusive: true, steps: 40).ramp
fade_in1 = (line 0, 3, inclusive: true, steps: 15).ramp
fade_out = (line 3, 1, inclusive: true, steps: 40).ramp
fade_out1 = (line 2, 0.5, inclusive: true, steps: 15).ramp
fade_out2 = (line 3, 1.5, inclusive: true, steps: 40).ramp
fade_through = fade_in+fade_out
fade_through1 = fade_in+fade_out1
fade_through2 = fade_in+fade_out2

background_chords = [(chord :C, :minor7), (chord :Ab, :major7), (chord :Eb, :major7), (chord :Bb, "7")].ring
c = background_chords[0]

intro = (ring :d, :a,  :f5, :a, :d, :Bb, :g5, :Bb)
x=0
use_synth :tri

define :start_loop do |i|
  tracker[i] = 1
end

define :stop_loop do |i|
  tracker[i] = 0
end

define :stop_all do
  tracker[0] = 0
  tracker[1] = 0
  tracker[2] = 0
  tracker[3] = 0
  tracker[4] = 0
  tracker[5] = 0
  tracker[6] = 0
  tracker[7] = 0
  tracker[8] = 0
  tracker[9] = 0
  tracker[10] = 0
  tracker[11] = 0
end

define :silence_all do
  volume[0] = 0
  volume[1] = 0
  volume[2] = 0
  volume[3] = 0
  volume[4] = 0
  volume[5] = 0
  volume[6] = 0
  volume[7] = 0
  volume[8] = 0
  volume[9] = 0
  volume[10] = 0
  volume[11] = 0
end

# Reduce any particular sound loop's volume
define :reduce_loop do |i, n |
  if volume[i] - n > 0 then
    volume[i] = volume[i] - n
  end
end

# Increase any particular sound loop's volume
define :increase_loop do |i, n |
  if volume[i] + n < 10 then
    volume[i] = volume[i] + n
  else
  end
end

define :fade_in_piano do
  fade_in 7
  fade_in 8
  fade_in 9
  fade_in 10
  fade_in 11
end

# Fade out various parts of the piano tinkle in the right order.
define :fade_out_piano do
  fade_out 11
  fade_out 10
  fade_out 9
  fade_out 8
  fade_out 7
end

# Start with all loops/volumes at 0, slowly bring each one up to 10.
define :fade_in do |i|
  tracker[i] = 1
  3.times do
    if volume[i] < 3 then
      volume[i] += 1
      sleep 1
    end
  end
end

# Start with all loops/volumes at 10, slowly fade each one down to 0
define :fade_out do |i|
  3.times do
    if volume[i] > 0 then
      volume[i] -= 1
      sleep 1
    end
  end
  tracker[i] = 0
end


define :pat do |a|
  use_bpm 80
  with_fx :reverb do
    a[:count].times do |i|
      # volume varies randomly around the specified level
      variance = rrand(0, 0.1)
      play a[:notes][i], amp: volume[a[:loop]]*(a[:amps][i] + variance), release: a[:rel] || a[:time]
      sleep a[:time]
    end
  end
end
live_loop :bar do
  sleep 1
end

live_loop :beats do
  sync :bar
  sleep 4
end

live_loop :echo1 do
  use_synth :fm
  vol = 0.25
  with_fx :reverb, room: 0.9 do
    with_fx :slicer, phase: 0.4 do
      if tracker[1]>0 then
        sync :beats
        play_chord [[:C2, :Eb3, :Ab4],[:D2, :F3, :Ab4]].choose,
          cutoff: rrand(100,130), pan: -0.25,
          amp: vol, env_curve: 7, decay: 1.6, release: 1.6
        sleep 3.2
        with_fx :slicer, phase: 0.4 do
          play_chord [[:C3, :Eb3, :G3],[:Bb2, :Eb3, :G3]].choose,
            cutoff: rrand(100,130), pan: 0.25,
            amp: vol*fade_in1.tick, env_curve: 7, decay: 1.6, release: 1.6
          sleep 3.2
        end
      else
        sleep 0.2
      end
    end
  end
end

live_loop :echo2 do
  if tracker[2]>0 then
    sync :beats
    with_fx :echo, phase: 6.4 / 12, decay: 6.4, mix: 0.9 do
      use_synth :fm
      play_pattern_timed [:C3, :Eb2, :G2, :Ab2], [0.4, 0.4, 0.4, 0.2],
        cutoff: rrand(60,110), res: rrand(0.01,0.25),
        amp: 0.5, env_curve: 1, decay: 0.25,
        sustain: 0.5, sustain_level: 0
    end
  else
    sleep 0.2
  end
end

live_loop :eerie1, auto_cue:false do
  if tracker[3] > 0 then
    vol = volume[3] * 0.1
    if one_in(6) then sample :ambi_glass_hum, amp: vol, rate: 1.189207115002721
      sleep 0.1
    end
  else
    sleep 0.1
  end
  sleep 0.1
end

live_loop :eerie2, auto_cue:false do
  if tracker[4] > 0 then
    vol  = volume[4] * 0.1
    if one_in(3) then sample :ambi_glass_rub, amp: vol, rate: 0.6
      sleep 0.1
    end
  else
    sleep 0.1
  end
  sleep 0.1
end


live_loop :bang, auto_cue:false do
  if tracker[5] > 0 then
    bang_vol = volume[5] * 0.2
    with_fx :reverb, room: 1 do
      sample :bd_boom, amp: bang_vol, rate: 3
      sample :bd_fat, amp: bang_vol, rate: 1
      sample :bd_boom, amp: bang_vol, rate: 2
      sample :bd_fat, amp:  bang_vol, rate: 9
    end
    if tracker[6] > 0 then
      hum_vol= volume[6]*0.09
      guitar_vol = volume[6]*0.2
      sample :ambi_glass_hum, amp: hum_vol, rate: 0.2
      with_fx :echo, mix: 0.9, phase: 0.25 do
        sample :guit_em9, amp: guitar_vol, rate: 0.5
      end
    end
  end
  sleep 10
end

live_loop :pianozero do
  if tracker[7] > 0 then
    pat loop: 7, count: 12,
      notes: (ring :c4, :eb4), amps: (ring 0.3, 0.2, 0.2),
      time: 1/3.0, rel: 0.45
  else
    sleep 0.1
  end
end


live_loop :pianoone do
  sync :pianozero
  if tracker[8] > 0 then
    pat loop: 8, count: 12,
      notes: (ring :g4, :bb5), amps: (ring 0.2, 0.1, 0.1),
      time: 1/3.0, rel: 0.4
  else
    sleep 0.1
  end
end

live_loop :pianotwo, auto_cue:false do
  sync :pianozero
  if tracker[9] > 0 then
    if volume[9] != 0 then pat loop: 9, count: 8,
        notes: (ring :c4, :bb3, :ab3), amps: (ring 0.35, 0.3, 0.3),
        time: 8 # don't start playing until we fade in, keeps in sync better
    end
  else
    sleep 0.1
  end
end

live_loop :pianothree, auto_cue:false do
  sync :pianozero
  if tracker[10] > 0 then
    if volume[10] != 0 then pat loop: 10, count: 8,
        notes: (ring :eb4), amps: (ring 0.4, 0.3, 0.3),
        time: 8, rel: 7
    end
  else
    sleep 0.1
  end
end

live_loop :pianofour, auto_cue:false do
  sync :pianozero
  if tracker[11] > 0 then
    if volume[11] != 0 then pat loop: 11, count: 24,
        notes: (ring :bb5, :eb5, :g6, :eb5, :g6, :eb5), amps: (ring 0.2, 0.1, 0.1),
        time: 1/6.0
    end
  else
    sleep 0.1
  end
end




echo1=1
echo2=2
eerie1 =3
eerie2 = 4
bang = 5
bang_guitar = 6
piano0 = 7
piano1 = 8
piano2 = 9
piano3 = 10
piano4 = 11



silence_all
stop_all

increase_loop eerie1,1
start_loop eerie1
sleep 8
increase_loop eerie1,1
sleep 8
increase_loop eerie2,1
start_loop eerie2
sleep 8
increase_loop eerie2,1
sleep 12
increase_loop echo1,1
start_loop echo1
sleep 8
increase_loop echo1,1
sleep 12
stop_loop echo1
sleep 8
stop_loop eerie1
stop_loop eerie2
reduce_loop eerie1, 2
reduce_loop eerie2, 2
increase_loop 5,2
start_loop bang
sleep 32
increase_loop 6,2
start_loop bang_guitar
sleep 24
stop_loop bang_guitar
sleep 8
stop_loop bang
fade_in_piano
sleep 32
fade_out_piano
increase_loop 5,2
start_loop bang
sleep 16
increase_loop 6,2
start_loop bang_guitar
sleep 24
stop_loop bang_guitar
sleep 8
stop_loop bang
silence_all
stop_all