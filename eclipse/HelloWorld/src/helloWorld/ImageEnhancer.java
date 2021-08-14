/**
 * 
 */
package helloWorld;

import java.awt.image.VolatileImage;

/**
 * @author nesko
 *
 */
public interface ImageEnhancer {
	
	public VolatileImage enhanceImage(VolatileImage bitmap, int configuration);
	public String[] getConfigurationOptions();
}
