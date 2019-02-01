set ns [new Simulator]


$ns color 1 Blue
$ns color 2 Red


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
        exit 0
}

proc rand_range {min max} { return [expr int(rand()*($max-$min+1)) + $min] }

for {set i 0} {$i < 8} {incr i} {
    set n($i) [$ns node]
}

for {set i 0} {$i < 7} {incr i} {
    $ns duplex-link $n($i) $n(7) 1Mb 10ms DropTail
}

$ns duplex-link-op $n(7) $n(0) orient left-up
$ns duplex-link-op $n(7) $n(1) orient left-down
$ns duplex-link-op $n(7) $n(2) orient down
$ns duplex-link-op $n(7) $n(3) orient right-down
$ns duplex-link-op $n(7) $n(4) orient right
$ns duplex-link-op $n(7) $n(5) orient right-up
$ns duplex-link-op $n(7) $n(6) orient up

set i -1
set j -1

while { $i == $j } {
	set i [rand_range 0 7]
	set j [rand_range 0 7]
}


set tcp0 [new Agent/TCP]

$ns attach-agent $n($i) $tcp0
set sink [new Agent/TCPSink]
$ns attach-agent $n($j) $sink
$ns connect $tcp0 $sink
$tcp0 set fid_ 1


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP


$ns at 0.1 "$ftp0 start"
$ns at 2 "$ftp0 stop"

$ns at 10.0 "finish"
$ns run



