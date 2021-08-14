package helloWorld;

import java.awt.image.VolatileImage;
import java.awt.image.Raster;
import java.awt.image.DataBufferInt;
import java.awt.Color;
import java.lang.Math;
//import android.graphics.Color;
//import android.graphics.Bitmap.Config;

public class HaarDenoising implements ImageEnhancer {

    private static final int ACTION_3 = 3;
	private static final int ACTION_2 = 2;
	private static final int ACTION_1 = 1;
	private static final int ACTION_0 = 0;
	private int progress;

	public HaarDenoising() {
	}
	
	public static int log2(int a)
	{
		// calculate log2 for int a
	    return (int) (Math.log(a) / Math.log(2));
	}
	
	public static double sigthresh(Matrix M, int level, Matrix test_matrix) {
		int[] dim = M.getDimensions();
		int length = Math.max(dim[0], dim[1]);
		
		double c = 0.6745;
		double variance = Math.pow(M.abs().median() / c, 2);
		double beta = Math.sqrt((double)Math.log(length) / level);
		double T = beta * variance / test_matrix.std2();
		return T;
	}

	public Matrix Haar2D(Matrix X) {
		double[][] lr_filter = { { 0.25, 0.25}, { 0.25, 0.25} };
		double[][] hc_filter = { { 0.25, 0.25}, { -0.25, -0.25} };
		double[][] vc_filter = { { 0.25, -0.25}, { 0.25, -0.25} };
		double[][] dc_filter = { { 0.25, -0.25}, { -0.25, 0.25} };

		Matrix w1 = X.convWithStride(new Matrix(lr_filter));
		Matrix w2 = X.convWithStride(new Matrix(hc_filter));
		Matrix w3 = X.convWithStride(new Matrix(vc_filter));
		Matrix w4 = X.convWithStride(new Matrix(dc_filter));
		
		Matrix resultH_up = w1.concatH(w2);
		Matrix resultH_down = w3.concatH(w4);

		return resultH_up.concatV(resultH_down);
	}
	
	public Matrix full_Haar2D(Matrix X, int level) {
	    // requirement: level < max_levlels = min(lev_rows - 1, lev_cols - 1) where
	    // lev_rows = log2(m);
	    // lev_cols = log2(n);
		int dim_reduction;
		int[] dim = X.getDimensions();
		Matrix Forward = X;

		for (int i = 1; i < level; i++) {
	        // dim reduction for 2dhaar transform depending on the transform level
	        dim_reduction = (int) Math.pow(2, i-1);
	        Forward = Haar2D(Forward.reduce(dim[0]/dim_reduction, dim[1]/dim_reduction));
		}
		return Forward;
	}
	
	public Matrix iHaar2D(Matrix X) {
		double[][] x = X.getData();
		int[] dim = X.getDimensions();
		int mm = dim[0] / 2;
		int nn = dim[1] / 2;
		double[][] y = new double[dim[0]][dim[1]];
		
		double[][] w1 = new double[mm][nn];
		double[][] w2 = new double[mm][nn];
		double[][] w3 = new double[mm][nn];
		double[][] w4 = new double[mm][nn];
		
		for (int i = 0; i < mm; i++) {
	        System.arraycopy(x[i], 0, w1[i], 0, nn);
	        System.arraycopy(x[i], nn, w2[i], 0, nn);
	        System.arraycopy(x[mm + i], 0, w3[i], 0, nn);
	        System.arraycopy(x[mm + i], nn, w4[i], 0, nn);
		}
		for (int i = 0 ; i < mm; i++) {
			int ii= i * 2 - 1;
			for (int j = 0; j < nn; j++) {
				int jj = j * 2 - 1;
				y[ii][jj]     = w1[i][j] + w2[i][j] + w3[i][j] + w4[i][j];
	            y[ii][jj+1]   = w1[i][j] + w2[i][j] - w3[i][j] - w4[i][j];
	            y[ii+1][jj]   = w1[i][j] - w2[i][j] + w3[i][j] - w4[i][j];
	            y[ii+1][jj+1] = w1[i][j] - w2[i][j] - w3[i][j] + w4[i][j];
			}
		}
		return new Matrix(y);
	}
	
	public Matrix full_iHaar2D(Matrix X, int level) {
		// 2D Haar inverse wavelet transform
		// assuming the dimensions are the power of 2!
		// level determines number of ihaar2d iterations
		// Iout_inverse = higher-resolution image
		int dim_reduction;
		int[] dim = X.getDimensions();
		Matrix Inverse = X;

		for (int i = level; i > 0; i--) {
	        // dim reduction for 2dhaar transform depending on the transform level
	        dim_reduction = (int) Math.pow(2, i-1);
	        Inverse = iHaar2D(Inverse.reduce(dim[0]/dim_reduction, dim[1]/dim_reduction));
		}
		return Inverse;
	}

	public VolatileImage enhanceImageHSV(VolatileImage theImage, int action) {

		// Set progress
		progress = 0;
		
		// Get the image pixels
		int height = theImage.getHeight();
		int width = theImage.getWidth();
		// Log.d("DEBUG", "Image size is " + width + "px by " + height + "px." );
		// int[] pixels = new int[height * width];
		// theImage.getPixels(pixels, 0, width,0,0, width, height);
		Raster raster = theImage.getSnapshot().getData();
		int[] pixels = ((DataBufferInt) theImage.getSnapshot().getData().getDataBuffer()).getData();
		progress = 5;

		// Log.d("DEBUG", "pixels length = " + pixels.length);
		
		//Convert pixels to brightness values;
		float[][] hsvPixels = convertToHSV(pixels);
		
		progress = 40;
		
		// Log.d("DEBUG", "hsvPixels length = " + hsvPixels.length);

		// Here below some manipulations of the image is made as examples.
		// This should be changed to your image enhancement algorithms.
		if (action != ACTION_3) {
            float maxValue = 0;
            for (int i = 0; i < hsvPixels.length; i++) {
                if (maxValue < hsvPixels[i][action]) maxValue = hsvPixels[i][action];
            }
            // Log.d("DEBUG", "maxValue of hsvPixels = " + maxValue);
            progress = 60;

            for (int i = 0; i < hsvPixels.length; i++) {
                hsvPixels[i][action] = maxValue - hsvPixels[i][action];
                pixels[i] = Color.HSVToColor(hsvPixels[i]);
            }
        } else {
            for (int i = 0; i < hsvPixels.length; i++) {
                hsvPixels[i][1] = 0; // Set color saturation to zero
                pixels[i] = Color.HSVToColor(hsvPixels[i]);
            }
            // Log.d("DEBUG", "saturation zeroed");
        }
		progress = 80;
		// Log.d("DEBUG","creating BITMAP,width x height "+width+" "+height);
        VolatileImage modifiedImage = VolatileImage.createBitmap(width, height, Config.ARGB_8888);
		modifiedImage.setPixels(pixels, 0, width, 0, 0, width, height);

		progress = 100;
		return modifiedImage;
	}

	private float[][] convertToHSV(int[] pixels) {
		float[][] hsvPixels = new float[pixels.length][3];
		for (int i = 0; i < pixels.length; i++) {
			Color.RGBToHSB(Color.red(pixels[i]), Color.green(pixels[i]), Color.blue(pixels[i]), hsvPixels[i]);
			
		}
		return hsvPixels;
	}

	public int getProgress() {
		// Log.d("DEBUG", "Progress: "+progress);
		return progress;
	}

	@Override
	public VolatileImage enhanceImage(VolatileImage bitmap, int configuration) {
		switch (configuration) {
		case ACTION_0:
			return enhanceImageHSV(bitmap, 0);
		case ACTION_1:
			return enhanceImageHSV(bitmap, 1);
		case ACTION_2:
			return enhanceImageHSV(bitmap, 2);
        case ACTION_3:
            return enhanceImageHSV(bitmap, 3);
		default:
			return enhanceImageHSV(bitmap, 0);
		}
	}

	@Override
	public String[] getConfigurationOptions() {
		return new String[]{ "Action 0", "Action 1", "Action 2", "Action 3"};
	}
}
