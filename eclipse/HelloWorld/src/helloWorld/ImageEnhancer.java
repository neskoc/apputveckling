/**
 * 
 */
package helloWorld;

import java.awt.image.BufferedImage;

/**
 * @author nesko
 *
 */
public interface ImageEnhancer {
	
	public BufferedImage enhanceImage(BufferedImage bitmap, int configuration);
	public String[] getConfigurationOptions();
}
