set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround
set val(netif)	Phy/WirelessPhy
set val(mac) 	Mac/802_11
set val(ifq)	Queue/DropTail/PriQueue
set val(ll) 	LL
set val(ant) 	Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn)		6
set val(rp)		AODV
set val(x)		700
set val(y)		700
set val(stop)	60


set ns [new Simulator]
set tf [open l9.tr w]
$ns trace-all $tf

set nf [open l9.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

$ns node-config -adhocRouting $val(rp) \
		 -llType $val(ll) \
		 -macType $val(mac) \
		 -ifqType $val(ifq) \
		 -ifqLen $val(ifqlen) \
		 -antType $val(ant) \
		 -propType $val(prop) \
		 -phyType $val(netif) \
		 -channelType $val(chan) \
		 -topoInstance $topo \
		 -agentTrace ON \
		 -routerTrace ON \
		 -macTrace ON \
		 
for {set i 0} {$i<$val(nn)} {incr i} {
 set node_($i) [$ns node]	
 $node_($i) random-motion 0
}

$node_(0) set X_ 150.0
$node_(0) set Y_ 300.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 300.0
$node_(1) set Y_ 500.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 500.0
$node_(2) set Y_ 500.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 300.0
$node_(3) set Y_ 100.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 500.0
$node_(4) set Y_ 100.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 650.0
$node_(5) set Y_ 300.0
$node_(5) set Z_ 0.0

for {set i 0} {$i<$val(nn)} {incr i} {
$ns initial_node_pos $node_($i) 40
}

$ns at 4.0 "$node_(3) setdest 300.0 500.0 5.0"


set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(5) $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 3.0 "$ftp0 start"
#$ns at 10.0 "$ftp0 stop"

for {set i 0} {$i<$val(nn)} {incr i} {
$ns at $val(stop) "$node_($i) reset";
}

$ns at $val(stop) "puts \"NS EXITING ...\"; $ns halt"
puts "Starting Simulation ... "

$ns run


