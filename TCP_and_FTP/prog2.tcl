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
set n2 [$ns node]


$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

$ns queue-limit $n1 $n2 10

$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up

$ns duplex-link-op $n1 $n2 queuePos 0.5

set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns at 0.1 "$ftp start"
$ns at 1 "$ftp stop"

$ns at 2 "$ns detach-agent $n0 $tcp"

$ns at 5.0 "finish"

$ns run
