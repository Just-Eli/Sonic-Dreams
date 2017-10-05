# Safari - classic hip-hop.
# Just Eli 2016

use_bpm 110
tracker = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0]

snare_effect = 0 # 1 for echo snare.

# Bring in a loop.
define :start_loop do |i|
  tracker[i] = 1
end

# Remove a loop.
define :stop_loop do |i|
  tracker[i] = 0
end

live_loop :bar do
  sleep 1
end

live_loop :half do
  sleep 2
end

live_loop :beats do
  sync :bar
  sleep 4
end

with_fx :distortion, mix: 0.06 do
  with_fx :nrhpf, mix: 0.05 do
    
    live_loop :drum do
      sync :bar
      if tracker[0]>0 then
        sample :bd_haus, amp: 2
        sleep 1
      else
        sleep 0.25
      end
    end
    
    
    live_loop :loops do
      if tracker[1]>0 then
        sync :beats
        sample [:loop_compus,:loop_safari].choose, beat_stretch: 4, amp: 2, rate: 0.5
        sleep 0.1
      else
        sleep 0.1
      end
    end
    
    live_loop :snaps do
      if tracker[3]>0 then
        sync :bar
        sleep 1
        with_fx :reverb, mix: 0.5 do
          sample :perc_snap, amp: 1.5 if rand(1) < 0.7
        end
        sleep 1
      else
        sleep 0.25
      end
    end
    
    live_loop :tune1 do
      if tracker[4]>0 then
        use_synth :blade
        use_synth_defaults release: rrand(0.05, 0.25), amp: rrand(1.5, 2)
        with_fx :reverb, mix: 0.2 do
          trans = [12, 24, 0].ring
          2.times do
            with_transpose trans.look do
              note = (ring :C2, :C3, :r, :Eb3, :r, :G2, :Bb2, :r)
              play note.tick, cutoff: rrand(40, 120)
            end
          end
          tick
        end
        sleep 0.25
      else
        sleep 0.25
      end
    end
    
    live_loop :tune2 do
      if tracker[5]>0 then
        if one_in(4) then
          use_synth_defaults release: rrand(0.5, 0.25), amp: rrand(1.5, 2)
          use_synth :pluck
        else
          use_synth_defaults release: rrand(0.05, 0.25), amp: rrand(1.5, 2)
          use_synth :piano
        end
        with_fx :reverb, mix: 0.2 do
          8.times do
            note = (ring :C2, :C3, :r, :Eb3, :r, :G2, :Bb2, :r)
            play note.tick, cutoff: rrand(40, 120)
            sleep 0.25
          end
          sleep 0.25
        end
      else
        sleep 0.25
      end
    end
    
    live_loop :intro do
      if tracker[6]>0 then
        with_fx :reverb, mix: 0.4 do
          with_fx :echo, mix: 0.7 do
            sample :ambi_swoosh, amp: 2
            sleep 3
            with_fx :flanger do
              sample :elec_wood, rate: 2
              sleep 1
            end
          end
        end
        
      else
        sleep 1
      end
    end
    
    live_loop :intro1 do
      if tracker[7]>0 then
        sync :bar
        use_synth :prophet
        use_synth_defaults cutoff: rrand(70, 110), release: rrand(1, 4), amp: 1
        with_fx :panslicer, mix: 0.5 do
          with_fx :hpf, cutoff: 70 do
            with_fx :reverb, mix: 0.4 do
              with_fx :echo, mix: 0.2 do
                2.times do
                  play_chord chord(:D3, :minor )
                  sleep 0.75
                end
                sleep 0.5
                play_chord chord(:D4, :minor ), attack: 4, release: 2
                sleep 2
              end
            end
          end
        end
      else
        sleep 0.25
      end
    end
    
    
  end
end

live_loop :bass1 do
  if tracker[9]>0 then
    use_synth :mod_fm
    use_synth_defaults release: 0.125 + rrand(0, 0.2), amp: 1.5, pan: rrand(-0.5, 0.5)
    
    use_transpose -12
    use_transpose 0 if one_in(3)
    
    n = (ring :r, :r, :d2, :d3, :f3, :r, :d1, :f2).tick
    play n, cutoff: rrand(30, 130)
    
    sleep 0.25
  else
    sleep 1
  end
end

live_loop :bass2 do
  if tracker[9]>0 then
    use_synth :piano
    use_synth_defaults release: rrand(0.1, 0.3), amp: 0.8, pan: rrand(-0.5, 0.5)
    use_transpose 0
    use_transpose 12 if one_in(3)
    with_fx :bitcrusher, mix: 0.5 do
      with_fx :echo, mix: 0.6 do
        n = (ring :r, :d2, :d3, :f3, :r, :d1, :f2, :r).tick
        play n, cutoff: rrand(70, 120)
      end
    end
    sleep 0.25
  else
    sleep 1
  end
end

live_loop :snare do
  if tracker[10] > 0 then
    sync :beat
    # Standard electric snare.
    if snare_effect == 0 then
      with_fx :reverb, room: 0.5, mix: 0.25 do
        2.times do
          sleep 1
          sample :elec_hi_snare, finish: 0.75, rate: 0.75, pan: -0.3, amp: 1.0
          sleep 1
        end
      end
    end
    #Phased electric snare
    if snare_effect == 1 then
      with_fx :echo, phase: [0.25, 0.5, 0.75].choose, decay: 8, mix: 0.5 do
        2.times do
          sleep 1
          #sample :drum_snare_hard, rate: 2, pan: -0.3, amp: 1
          sample :elec_hi_snare, finish: 0.75, rate: 0.75, pan: -0.3, amp: 1.0
          sleep 1
        end
      end
    end
    # Standard hard snare.
    if snare_effect == 2 then
      with_fx :reverb, room: 0.5, mix: 0.25 do
        2.times do
          sleep 1
          sample :drum_snare_hard, rate: 2, pan: -0.3, amp: 1
          sleep 1
        end
      end
    end
    #Phased hard snare
    if snare_effect == 3 then
      with_fx :echo, phase: [0.25, 0.5, 0.75].choose, decay: 8, mix: 0.5 do
        2.times do
          sleep 1
          sample :drum_snare_hard, rate: 2, pan: -0.3, amp: 1
          sleep 1
        end
      end
    end
  else
    sleep 0.1
  end
end

drum=0
loops=1
snaps=3
tune1=4
tune2=5
intro=6
intro2=7
bass1=9
bass2=9
snare=10


start_loop drum
sleep 4
start_loop snaps
sleep 8
start_loop loops
sleep 8
start_loop intro
sleep 3
stop_loop intro
start_loop tune1
sleep 16
start_loop tune2
sleep 16
stop_loop tune1
stop_loop tune2
start_loop snare
sleep 8
snare_effect = 1
sleep 8
stop_loop snare
sleep 16
start_loop tune2
start_loop tune1
sleep 16
stop_loop tune1
stop_loop tune2
sleep 16
start_loop 7
sleep 16
stop_loop 7
sleep 4
start_loop tune1
sleep 16
start_loop tune2
sleep 16
stop_loop tune1
stop_loop tune2
snare_effect = 0
start_loop snare
sleep 8
snare_effect = 1
sleep 8
stop_loop snare
sleep 16
start_loop tune2
start_loop tune1
sleep 16
stop_loop tune1
stop_loop tune2
sleep 16
stop_loop drum
stop_loop snaps
stop_loop loops
start_loop intro
sleep 3
stop_loop intro


