#Blue Horizons...
# Eli...

use_bpm 60

tracker = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

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

guitar_notes = (ring :r, :e3, :r, :r, :d3, :r, :a3, :r, :e2, :r, :d3, :r, :r, :a2)
clarinet_notes = (ring :d3, :e3, :d3,:a3, :d3, :g3, :a3, :e4)
clarinet_rhythm = (ring 0.25, 0.75, 1, 0.75, 0.25, 0.5, 0.5).shuffle

song_scale = :minor_pentatonic
song_note = :c2
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
end

live_loop :bar do
  sleep 1
end

live_loop :beats do
  sync :bar
  sleep 4
end

define :snare do
  at [0, 1, 2, 3],
  [{:amp=>0.3}, {:amp=> 1}, {:amp=>0.5}] do |p|
    sample :drum_cymbal_pedal, p
  end
end

define :drum1 do
  at [0, 2],
  [{:amp=>0.25}, {:amp=> 0.25}] do |p|
    sample :drum_heavy_kick, p
  end
end

define :drum2 do
  at [1],
  [{:amp=>0.5}, {:amp=> 0.125}] do |p|
    sample :bd_zum, p
  end
end

live_loop :do_snare do
  if tracker[0]>0 then
    sync :beats
    snare
    sleep 1
  else
    sleep 1
  end
end

live_loop :do_drum1 do
  if tracker[1]>0 then
    sync :beats
    drum1
    sleep 1
  else
    sleep 1
  end
end

live_loop :do_drum2 do
  if tracker[2]>0 then
    sync :beats
    drum2
    sleep 1
  else
    sleep 1
  end
end

live_loop :bass do
  if tracker[3]>0 then
    if rand(1) > 0.75
      n = (ring :r, :r, :d2, :d3, :f3, :r, :d1, :f2)
    else
      n=n.shuffle
    end
    use_synth :fm
    use_transpose +12
    use_synth_defaults release: 0.125 + rrand(0, 0.2), amp: 0.25, pan: rrand(-0.5, 0.5)
    use_transpose +12
    play n.look, cutoff: rrand(30, 130)
    sleep 0.25
    tick
  else
    sleep 1
  end
end

live_loop :clarinet do
  clarinet_transpose = (ring -0,12)
  if tracker[4]>0 then
    use_synth :fm
    if rand(1) <0.5 then
      clarinet_notes = (ring :d3, :e4, :r, :d4,:a3, :d3, :g3, :r, :a3, :e4)
    else
      clarinet_notes = clarinet_notes.shuffle
    end
    use_synth_defaults divisor: 0.5, depth: 4, attack: 0.05, sustain: 0.2,
      release: 0.2, amp: 0.05*fade_through1.look
    with_fx :reverb, room: 0.75, damp: 0.25 do
      #    use_transpose clarinet_transpose.tick
      play clarinet_notes.look # Playing the note 3 times gives it some
      play clarinet_notes.look # extra... 'depth'. Not sure why, I just
      play clarinet_notes.look # prefer it. Eli...
      sleep clarinet_rhythm.look
      tick
    end
  else
    sleep 0.25
  end
end

live_loop :piano do
  if tracker[5]>0 then
    sync :beats
    repeater = [4,8,8,8,8,16].choose
    repeater.times do
      s = (scale song_note, song_scale, num_octaves: 3).take(8)
      use_transpose +12
      synth :piano, amp: 0.25, note: s.choose, release: 3 if rand > 0.03
      sleep [0.5, 0.25].choose
    end
  else
    sleep 0.1
  end
end

live_loop :guitar do
  guitar_transpose = (ring 0,12)
  if tracker[6]>0 then
    if rand(1) > 0.75
      guitar_notes = (ring :d3, :e3, :r, :d3,:a3, :d3, :g3, :r, :a3, :e3)
    else
      guitar_notes = guitar_notes.shuffle
    end
    sleep 0.75
    use_synth :pluck
    use_transpose guitar_transpose.tick
    play_pattern_timed guitar_notes, 0.25, amp: 0.25, release: 2, sustain: 3
  else
    sleep 1
  end
end

snare=0
drum1=1
drum2=2
bass =3
clarinet=4
piano = 5
guitar = 6

use_random_seed 1024
start_loop piano
sleep 16

use_random_seed 2048
start_loop snare
start_loop drum1
start_loop drum2
sleep 12
stop_loop piano
sleep 4
start_loop bass
sleep 16
start_loop piano
sleep 16
stop_loop piano
sleep 2
start_loop clarinet
sleep 16
stop_loop clarinet
start_loop guitar
sleep 16
stop_loop guitar
sleep 2
use_random_seed 2048
start_loop piano
sleep 16
stop_loop piano
sleep 2
start_loop clarinet
sleep 8
start_loop guitar
sleep 8
stop_loop clarinet
stop_loop guitar
sleep 8
stop_all
