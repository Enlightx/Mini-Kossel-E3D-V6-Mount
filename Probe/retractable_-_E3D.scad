include <configuration.scad>;

use <microswitch.scad>;
//use <effector - E3D.scad>;

height = 26;
height2 = 26;
tunnel = 2.4;
face_offset = 4;
base_height = 2;

module foot() {
  difference() {
    translate([12.5, 0, 0]) rotate([0, 0, -60])
      translate([-12.5, 0, 1]) rotate([0, 0, -60]) union() {
        cylinder(r=5, h=base_height, center=true, $fn=100);
        translate([10, 0, 0])
          cube([20, 10, base_height], center=true);
    }
    translate([0, -10, 0])
      cube([40, 20, 20], center=true);
    translate([12.5, 0, 0]) {
      // Space for bowden push fit connector.
      cylinder(r=6.49, h=3*height, center=true, $fn=32);
      for (a = [60:60:360]) {
	    rotate([0, 0, a]) translate([-12.5, 0, 0])
          %cylinder(r=m3_wide_radius, h=20, center=true, $fn=24);
      }
    }
  }
}

module base() {
	difference() {
		union() {
			translate([-5, -7.5, 0])
			cube([10, 13.5, base_height]);
			// Additional support on right.
			translate([-13.5, 3, 0])
			rotate([0, 0, -75])
			cube([11, 8, base_height]);
			// Additional support on left.
			translate([5.5, -10.75, 0])
			rotate([0, 0, 60])
			cube([15, 6, base_height]);

			// Feet for vertical M3 screw attachment.
   		rotate([0, 0, 90]) {
      		foot();
		   	scale([1, -1, 1]) 
					foot();
			}
		}

		// Remove mounting holes.
		translate([0, 12.5, 0])
		rotate([0, 0, 30])
      for (a = [60:60:360]) {
	    rotate([0, 0, a]) translate([-12.5, 0, 0])
          cylinder(r=m3_wide_radius, h=20, center=true, $fn=24);
      }
	}
}

module retractable() {
 union() {
  base();

  translate([0, -9, 0])
  difference() {
    union() {
      translate([0, 0, height/2])
        cylinder(r=6, h=height, center=true, $fn=100);
      translate([0, -3, height/2])
        cube([12, 6, height], center=true);
      // Lower part on the left.
      translate([-6, 0, height2/2])
        cylinder(r=6, h=height2, center=true, $fn=100);
      translate([-3, 0, height2/2])
        cube([6, 12, height2], center=true);
      translate([-3, -3, height2/2])
        cube([18, 6, height2], center=true);
    }
    translate([-19, 0, height/2+6]) rotate([0, 15, 0])
      cube([20, 20, height], center=true);
    cylinder(r=tunnel/2, h=3*height, center=true, $fn=100);
    translate([0, -6, height/2+12])
      cube([tunnel + 0.25, 12, height], center=true);
    rotate([0, 0, 30]) translate([0, -6, height/2+22])
      cube([tunnel, 12, height], center=true);
    // Safety needle spring.
    translate([-4.5, 0, height-11]) rotate([90, 0, 0])
      cylinder(r=2.5/2, h=40, center=true, $fn=12);
    translate([-4, 0, height-2]) rotate([90, 0, 0])
      cylinder(r=1/2, h=40, center=true, $fn=12);
    // Effector screw heads.
    rotate([0, 0, 330]) translate([-12.5, 0, 2])
      cylinder(r=4, h=30, $fn=24);
    // Flat front face.
    translate([0, -face_offset-10, height/2]) difference() {
      cube([30, 20, 2*height], center=true);
    }
    // Sub-miniature microswitch.
    translate([-2.5, -face_offset-3, 5]) {
      % microswitch();
      for (x = [-9.5/2, 9.5/2]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
          cylinder(r=2.5/2, h=40, center=true, $fn=12);
      }
    }
  }
 }
}

retractable();