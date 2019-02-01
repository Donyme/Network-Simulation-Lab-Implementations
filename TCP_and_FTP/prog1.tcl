set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set tf [open out.tr w]
$ns trace-all $tf

proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $nf
	close $tf
	exec nam out.nam &
	exit0
}

set n0 [$ns node]
set n1 [$ns node]


$ns duplex-link $n0 $n1 1Mb 10ms DropTail


set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0


set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

set null1 [new Agent/Null]
$ns attach-agent $n0 $null1


$ns connect $udp0 $null0


$ns at 0.5 "$cbr0 start"
$ns at 2.5 "$cbr0 stop"

$ns connect $udp1 $null1


$ns at 2.5 "$cbr1 start"
$ns at 5 "$cbr1 stop"

$ns at 5.0 "finish"

$ns run


#grep ^r out.tr| wc -l


