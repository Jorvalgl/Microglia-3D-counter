/* 
    Microglia_3Dcounter.ijm is an ImageJ macro developed to quantify microglia soma in 3D,
    Copyright (C) 2023  Jorge Valero Gómez-Lobo.

   Microglia_3Dcounter is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Microglia_3Dcounter is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//This macro has been developed by Dr Jorge Valero (jorge.valero@achucarro.org). 
//If you have any doubt about how to use it, please contact me.

//License
Dialog.create("GNU GPL License");
Dialog.addMessage(" Microglia_3Dcounter  Copyright (C) 2023 Jorge Valero Gomez-Lobo.");
Dialog.setInsets(10, 20, 0);
Dialog.addMessage(" Microglia_3Dcounter comes with ABSOLUTELY NO WARRANTY; click on help button for details.");
Dialog.setInsets(0, 20, 0);
Dialog.addMessage("This is free software, and you are welcome to redistribute it under certain conditions; click on help button for details.");
Dialog.addHelp("http://www.gnu.org/licenses/gpl.html");
Dialog.show();

// Get the title of the current image
name = getTitle(); 

// Call the DifGaus function with minimum and maximum values as 0 and 20
DifGaus(0, 20);

// Call the OpenFil function with parameters 3 and 2
OpenFil(3, 2);

// Set the threshold values for image intensity from 1 to 255
setThreshold(1, 255);

// Call the Object3D function with threshold 1 and size 500
Object3D(1, 500);

function DifGaus(min, max){
  // Create a duplicate of the current image with a title "min duplicate"
  run("Duplicate...", "title=min duplicate");

  // Apply Gaussian blur with sigma value as the minimum value provided
  run("Gaussian Blur...", "sigma="+min+" stack");

  // Create another duplicate of the current image with a title "max duplicate"
  run("Duplicate...", "title=max duplicate");

  // Apply Gaussian blur with sigma value as the maximum value provided
  run("Gaussian Blur...", "sigma="+max+" stack");

  // Subtract the "max" image from the "min" image using image calculator
  imageCalculator("Subtract stack", "min", "max");

  // Select the "max" image window
  selectWindow("max");

  // Close the "max" image window
  close();

  // Select the "min" image window
  selectWindow("min");

  // Rename the "min" image to "DifGauss"
  rename("DifGauss");
}

function OpenFil(val, z){
  // Apply 3D minimum filtering with the specified values
  run("Minimum 3D...", "x="+val+" y="+val+" z="+z);

  // Apply 3D maximum filtering with the specified values
  run("Maximum 3D...", "x="+val+" y="+val+" z="+z);
}

function Object3D(th, size){
  // Set options for 3D object counting and analysis
  run("3D OC Options", "volume nb_of_obj._voxels centroid centre_of_mass dots_size=1 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

  // Run 3D object counting with the specified threshold and size parameters, and generate statistics summary
  run("3D Objects Counter", "threshold="+th+" slice=12 min.="+size+" max.=1000000000000000 objects statistics summary");
}

