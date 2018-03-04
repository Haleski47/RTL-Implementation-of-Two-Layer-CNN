onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__xxx__finish
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/xxx__dut__go
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__bvm__address
add wave -noupdate -radix hexadecimal /tb_top/dut_wrapper/dut/clockCount
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__bvm__enable
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__bvm__write
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__bvm__data
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/bvm__dut__data
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dim__address
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dim__enable
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dim__write
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dim__data
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dim__dut__data
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dom__address
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dom__data
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dom__enable
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/dut__dom__write
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/clk
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/reset
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/flag1
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/flag2
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/flag3
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/flag4
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/mReg
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/oTemp
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/zTemp
add wave -noupdate -radix decimal /tb_top/dut_wrapper/dut/oMac
add wave -noupdate -radix decimal -childformat {{{/tb_top/dut_wrapper/dut/oReg[7]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[6]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[5]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[4]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[3]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[2]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[1]} -radix decimal} {{/tb_top/dut_wrapper/dut/oReg[0]} -radix decimal}} -expand -subitemconfig {{/tb_top/dut_wrapper/dut/oReg[7]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[6]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[5]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[4]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[3]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[2]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[1]} {-radix decimal} {/tb_top/dut_wrapper/dut/oReg[0]} {-radix decimal}} /tb_top/dut_wrapper/dut/oReg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {25515 ns}
