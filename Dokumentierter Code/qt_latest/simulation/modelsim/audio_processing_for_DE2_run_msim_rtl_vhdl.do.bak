transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_Audio_Bit_Counter.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_Audio_In_Deserializer.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_Audio_Out_Serializer.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_Clock_Edge.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_I2C.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_I2C_AV_Auto_Initialize.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_Slow_Clock_Generator.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/Altera_UP_SYNC_FIFO.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/audio_and_video_config.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/audio_codec.v}
vlog -vlog01compat -work work +incdir+/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2 {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/clock_generator.v}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/files/audioDataPkg.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/files/topLevelDE2.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/circular_buffer.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/files/copy_machine_control_unit.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/files/copy_machine.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/files/buffer_register.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/output_files/denoising_auto_encoder.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/ACDI_DE2/ring_buffer_toplevel.vhd}
vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/files/compare_unit.vhd}

vcom -93 -work work {/home/julian/Documents/Julian_Hatzky/sonstiges/qt_latest/simulator/tb_testWithSimulator.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
