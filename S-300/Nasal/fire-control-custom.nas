
################### SAM INFO

var setupTime = 10;#minimum 'launcher_tilt_time' secs no matter what, due to anim and stuff.
var reload_time = 1;
var launcher_final_tilt_deg  = 90;
var launcher_start_tilt_deg  = 0;
var launcher_tilt_time       =  0;
var sam_align_to_target      =  0;
var launcher_align_to_target =  1;
var align_speed_dps          = 20;
var radar_elevation_above_terrain_m = 25;
var radar_lowest_pitch       = 3.5;# 0.5 degs = roughly 925 feet at 20 nm, 25 feet at half a nm. # 0.35 = roughly 925 feet at 20 nm, 25 feet at half a nm.
var radar_off_time_min         = 1;# When turning off to lure enemies into engagement zone, and to not make the SAM too easy to find, minimum turn off this duration.
var radar_off_time_max         = 2;# Bigger missile_max_distance give crew incentive to keep this a bit longer
var radar_on_time              = 10;# Minimum the time it would take to scan whole sky
var radar_on_after_detect_time = 240;# Crew is alert after spotting an aircraft, how long should they stay that way?
var can_detect_anti_rad        = 0.5;# 0.5 very good, 0 not at all.

#reaction tme for s-300p is 28 secs acording to http://www.astronautix.com/s/s-300p.html
# sounds a bit high for pmu, as its 4 secs for s-400

################### CIWS INFO

var ciws_installed =   0;
var ciws_domain_nm = 1.50; #range where it can kill
var ciws_chance    = 0.20; #chance to get a kill at 0nm distance
var ciws_burst_rounds = 60;#how many rounds in a burst
var ciws_shell = 15;#from lookup table in damage.nas
var ROUNDS_init       = 30;
var ROUNDS = ROUNDS_init;#CIWS bursts remaining

################### MISSILE INFO

var NUM_MISSILES = 3; # total carried minus 1
var missile_name = "M111";
var missile_brevity = damage.id2warhead[getprop("payload/armament/"~string.lc(missile_name)~"/type-id")][4];
var missile_max_distance = getprop("payload/armament/m111/max-fire-range-nm"); #max distance of target in nm when it will fire
var missile_min_distance = getprop("payload/armament/m111/min-fire-range-nm"); #minimum distance in nm when it will fire
var lockon_time = 2; #time in seconds it takes to lock on and get a firing solution on a target
var fire_minimum_interval = 7;# time since last track was initiated till a new can be initiated
var same_target_max_missiles = 3;# max number of missiles in air against same target

var isInEngagementEnvelope = func (v_rel, range_nm, alt_ft) {
    if (range_nm > missile_max_distance or range_nm < missile_min_distance) return 0;
    if (alt_ft < 100 or alt_ft > 82000) return 0; # Approximate low/high engagement limits
    if (v_rel < 50) return 0; # Low closure rate, maybe false target or chaff
    return 1;
}

var midflight = func (struct) {
	# This makes the SAM system keep lock on target when missile in-flight and no longer tracking the target.
	# Usage is to make the RWR lock sound go off in targets cockpit.
	thread.lock(mutexLock);
	semi_active_track = struct.callsign;
	thread.unlock(mutexLock);
	return {};
};


