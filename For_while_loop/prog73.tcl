set ns [new Simulator]
$ns rtproto DV

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
    $ns duplex-link $n($i) $n([expr ($i+1) % 7 ]) 1Mb 10ms DropTail
}

$ns duplex-link-op $n(0) $n(1) orient down
$ns duplex-link-op $n(1) $n(2) orient right-down
$ns duplex-link-op $n(2) $n(3) orient right
$ns duplex-link-op $n(3) $n(4) orient right-up
$ns duplex-link-op $n(4) $n(5) orient up
$ns duplex-link-op $n(5) $n(6) orient left-up
$ns duplex-link-op $n(6) $n(0) orient left-down

#set t [rand_range 2.5 8]
$ns rtmodel-at 3 down $n(5) $n(6)
$ns rtmodel-at 7 up $n(5) $n(6)


set i -1
set j -1

while { $i == $j } {
	set i [rand_range 0 7]
	set j [rand_range 0 7]
}


set tcp0 [new Agent/TCP]

$ns attach-agent $n(0) $tcp0
set sink [new Agent/TCPSink]
$ns attach-agent $n(5) $sink
$ns connect $tcp0 $sink
$tcp0 set fid_ 1


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP


$ns at 0.1 "$ftp0 start"
$ns at 10 "$ftp0 stop"

$ns at 10.0 "finish"
$ns run



