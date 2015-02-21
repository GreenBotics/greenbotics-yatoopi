// A nut for a hydroponic drain

flange_ht     = 5;
flange_dia    = 50;

hexa_ht       = 5;//see equivalent in drain file
hexa_dia      = 36;

main_dia_adj  = 0.3;
main_dia      = 25+main_dia_adj;

thread_pitch  = 2;//mm
thread_length = hexa_ht+flange_ht;

head_ht=0;
v_thread_len=(15/25.4);



// Thread library Open Source by Dan Kirshner - dan_kirshner@yahoo.com
include <threads.scad>

module body() {
	union () {
		// Flange
		cylinder(h=flange_ht,r=flange_dia/2);
		// Hexaonal bit
		translate([0,0,flange_ht])
		cylinder(h=hexa_ht,r=hexa_dia/2,$fn=6);
	}
}
module holes() {
	union () {
		// 3/4" BSPP thread
		//translate ([0,0,-0.1]) 
		metric_thread( main_dia, thread_pitch , thread_length, internal=false );
		//english_thread(1.06,14,v_thread_len);
	}
}

difference () {
	body();
	holes();
}

