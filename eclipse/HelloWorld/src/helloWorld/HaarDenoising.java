package helloWorld;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import java.awt.Color;
import java.lang.Math;
import java.util.Arrays;

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
		// calculate log2 for a (integer)
	    return (int) (Math.log(a) / Math.log(2));
	}
	
	public float[] getVfromHSV(float[][] pixels) {
		float[] vPixels = new float[pixels.length];
		for (int i = 0; i < pixels.length; i++) {
			vPixels[i] = pixels[i][2];
		}
		return vPixels;
	}

	public Matrix Haar2D(Matrix X) {
		float[][] lr_filter = { { (float) 0.25, (float) 0.25}, { (float) 0.25, (float) 0.25} };
		float[][] hc_filter = { { (float) 0.25, (float) 0.25}, { (float) -0.25, (float) -0.25} };
		float[][] vc_filter = { { (float) 0.25, (float) -0.25}, { (float) 0.25, (float) -0.25} };
		float[][] dc_filter = { { (float) 0.25, (float) -0.25}, { (float) -0.25, (float) 0.25} };

		Matrix w1 = X.convWithStride(new Matrix(lr_filter));
		Matrix w2 = X.convWithStride(new Matrix(hc_filter));
		Matrix w3 = X.convWithStride(new Matrix(vc_filter));
		Matrix w4 = X.convWithStride(new Matrix(dc_filter));
		
		Matrix resultH_up = w1.concatH(w2);
		Matrix resultH_down = w3.concatH(w4);

		return resultH_up.concatV(resultH_down);
	}
	
	public Matrix full_Haar2D(Matrix X, int level) {
	    // requirement: level < max_allowed_levlel = min(lev_rows - 1, lev_cols - 1) where
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
		float[][] x = X.getData();
		int[] dim = X.getDimensions();
		int mm = dim[0] / 2;
		int nn = dim[1] / 2;
		float[][] y = new float[dim[0]][dim[1]];
		
		float[][] w1 = new float[mm][nn];
		float[][] w2 = new float[mm][nn];
		float[][] w3 = new float[mm][nn];
		float[][] w4 = new float[mm][nn];
		
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
	        dim_reduction = (int) Math.pow(2, i);
	        Inverse = iHaar2D(Inverse.reduce(dim[0]/dim_reduction, dim[1]/dim_reduction));
		}
		return Inverse;
	}
	
	public static float sigthresh(Matrix M, int level, Matrix test_matrix) {
		int[] dim = M.getDimensions();
		int length = Math.max(dim[0], dim[1]);
		
		float c = (float) 0.6745;
		float variance = (float) Math.pow(M.abs().median() / c, 2);
		float beta = (float) Math.sqrt((float)Math.log(length) / level);
		return beta * variance / test_matrix.std2(); // T in Matlab
	}
	
	public Matrix apply_haar_filter(Matrix M, int level, String th_type, Matrix HH_matrix) {
		float threshold = sigthresh(M, level, HH_matrix);
		return M.apply_threshold(threshold, th_type);
	}

	public BufferedImage enhanceImageHSV(BufferedImage theImage, int action) {

		// Set progress
		progress = 0;
		
		// Get the image pixels
		int height = theImage.getHeight();
		int width = theImage.getWidth();
		int dim = height * width;
		// Log.d("DEBUG", "Image size is " + width + "px by " + height + "px." );
		// int[] pixels = new int[height * width];
		// theImage.getPixels(pixels, 0, width,0,0, width, height);
		int[] pixels = ((DataBufferInt) theImage.getRaster().getDataBuffer()).getData();
		progress = 5;

		// Log.d("DEBUG", "pixels length = " + pixels.length);
		
		//Convert pixels to brightness values;
		float[][] hsvPixels = convertToHSV(pixels);
		
		progress = 40;
		
		// Log.d("DEBUG", "hsvPixels length = " + hsvPixels.length);

		Color color = new Color(0);
		// Here below some manipulations of the image is made as examples.
		// This should be changed to your image enhancement algorithms.

	    float[] vPixels = getVfromHSV(hsvPixels);
		int lev_rows = log2(height);
	    int lev_cols = log2(width);
	    int mm = (int) Math.pow(2, lev_rows);
	    int nn = (int) Math.pow(2, lev_cols);
	    int level = 5;
	    String th_type = "soft";
	    int mw = mm / (int) Math.pow(2, level);
	    int nw = nn /  (int) Math.pow(2, level);

	    Matrix X = Matrix.array2Matrix(vPixels, width, height).expand(mm,nn);

	    Matrix Iout_hw = full_Haar2D(X, level);

	    Matrix w1 = Iout_hw.reduce(mw, nw);
	    Matrix w2 = Iout_hw.crop(mw, nw, nw, 0);
	    Matrix w3 = Iout_hw.crop(mw, nw, 0, mw);
	    Matrix w4 = Iout_hw.crop(mw, nw, nw, mw);
	    
	    w4 = apply_haar_filter(w4, level, th_type, w2);
	    w3 = apply_haar_filter(w3, level, th_type, w2);
	    w2 = apply_haar_filter(w2, level, th_type, w2);

	    Matrix Iout_forward = Iout_hw;
	    Matrix w1w2 = w1.concatH(w2);
	    Matrix w3w4 = w3.concatH(w4);
	    Matrix w1w2w3w4 = w1w2.concatV(w3w4);

	    Iout_forward.copy(w1w2w3w4);
	    Matrix Iout_inverse = full_iHaar2D(Iout_forward, level);
	    
//		if (action != ACTION_3) {
//            float maxValue = 0;
//            for (int i = 0; i < hsvPixels.length; i++) {
//                if (maxValue < hsvPixels[i][action]) maxValue = hsvPixels[i][action];
//            }
//            // Log.d("DEBUG", "maxValue of hsvPixels = " + maxValue);
//            progress = 60;
//
//            for (int i = 0; i < hsvPixels.length; i++) {
//                hsvPixels[i][action] = maxValue - hsvPixels[i][action];
//                color = Color.getHSBColor(hsvPixels[i][0],hsvPixels[i][1],hsvPixels[i][2]);
//                pixels[i] = color.getRGB();
//            }
//        } else {
//            for (int i = 0; i < hsvPixels.length; i++) {
//                hsvPixels[i][1] = 0; // Set color saturation to zero
//                color = Color.getHSBColor(hsvPixels[i][0],hsvPixels[i][1],hsvPixels[i][2]);
//                pixels[i] = color.getRGB();
//            }
//            // Log.d("DEBUG", "saturation zeroed");
//        }
		progress = 80;
		// Log.d("DEBUG","creating BITMAP,width x height "+width+" "+height);
		BufferedImage modifiedImage = new BufferedImage(width, height, BufferedImage.TYPE_4BYTE_ABGR);
		final int[] a = ( (DataBufferInt) modifiedImage.getRaster().getDataBuffer() ).getData();
		System.arraycopy(pixels, 0, a, 0, pixels.length);
		// modifiedImage.setPixels(pixels, 0, width, 0, 0, width, height);

		progress = 100;
		return modifiedImage;
	}

	private float[][] convertToHSV(int[] pixels) {
		Color color = new Color(0);
		float[][] hsvPixels = new float[pixels.length][3];
		for (int i = 0; i < pixels.length; i++) {
			color = new Color(pixels[i]);
			Color.RGBtoHSB(color.getRed(), color.getGreen(), color.getBlue(), hsvPixels[i]);
		}
		return hsvPixels;
	}

	public int getProgress() {
		// Log.d("DEBUG", "Progress: "+progress);
		return progress;
	}

	@Override
	public BufferedImage enhanceImage(BufferedImage bitmap, int configuration) {
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
