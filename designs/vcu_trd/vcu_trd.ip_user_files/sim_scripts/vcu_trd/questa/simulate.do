onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib vcu_trd_opt

do {wave.do}

view wave
view structure
view signals

do {vcu_trd.udo}

run -all

quit -force
