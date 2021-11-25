/**
 * Convolution
 * by Daniel Shiffman and  
 * Adapted by Dylan Seychell.
 *
 * Applies a convolution kernel to a portion of an image. Move mouse to 
 * apply filter to different parts of the image.
 */

PImage img;

//w is the size of the window that the user moves around 
//the screen when the cursor is moved.  w represents the width
//and height of the window.
int w = 800;

// It's possible to convolve the image with many different 
// kernels.  Below follow a selection of kernels doing differnt
// effects on the image.

float[][] sharpen =   { { -1, -1, -1 },
                        { -1,  9, -1 },
                        { -1, -1, -1 } }; 

float[][] edge =     { { -1, -1, -1 },
                       { -1,  8, -1 },
                       { -1, -1, -1 } }; 

float[][] emboss =     { { -2, -1, 0 },
                         { -1,  1, 2 },
                         {  0,  1, 2} };

//A single kernel for each process needs to be used at one point in time.
//The 'kernel' array can be filled with the values of the kernel with 
//the corresponding/desired effect.
float[][] kernel = emboss;

void setup() {
  size(700, 800);
  img = loadImage("duomo.png");
}

void draw() {
  // We're only going to process a portion of the image
  // so let's set the whole image as the background first
  image(img, 50, 50);
  
  // Calculate the small rectangle we will process.
  // All values are relative to the cursor coordinates.
  int xstart = constrain(height - w, 0, img.width);
  int ystart = constrain(width - w, 0, img.height);
  int xend = constrain(height + w, 0, img.width);
  int yend = constrain(width + w, 0, img.height);
  int kernelsize = 3;
  
  loadPixels();
  
  // Begin our loop for every pixel in the smaller image
  for (int x = xstart; x < xend; x++) {
    for (int y = ystart; y < yend; y++ ) {
      
      // convolution() is a custom function that is definded below 
      // c is the output of the convolution once the 'kernel' is applied on 'img'
      color c = convolution(x, y, kernel, kernelsize, img);
      //convert the pixel address from 2D to 1D.
      int loc = x + y*img.width;
      //the output pixel value at pixels[loc] takes the value of c
      pixels[loc] = c;
    }
  }
  updatePixels();
}

color convolution(int x, int y, float[][] kernel, int kernelsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = kernelsize / 2;
  
  for (int i = 0; i < kernelsize; i++){
    for (int j= 0; j < kernelsize; j++){
      
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * kernel[i][j]);
      gtotal += (green(img.pixels[loc]) * kernel[i][j]);
      btotal += (blue(img.pixels[loc]) * kernel[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
