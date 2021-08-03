#!/usr/bin/python
"""
 haar_denoise_2d.py image_file
"""

import os,pyfits,sys
from numpy import ones, log, int, log2, median,ceil,zeros,logical_or,where,empty,abs,sqrt

def usage():
    print __doc__
    sys.exit()

def transform(x,y,s):
    """ transform x to y on scale s"""
    y[:-2*s],y[-2*s:-s],y[-s:] = 2*x[s:-s]-x[:-2*s]-x[2*s:], 2*x[-s:]-x[-2*s:-s]-x[:s]-x[-1], 2*x[:s]-x[-s:]-x[s:2*s]+x[-1]

def haar_denoise_2d(data, thresh_fac=1.):
    """
    Non-decimated Haar wavelet denoising of an image:
      -> forward transform
      -> thresholding (coef>=thresh_fac),
      -> reconstruction (reverse transform).

    Inputs:
        data: 2d image to be denoised
        thresh_fac: adjust the treshold by this factor

    Output: denoised 2d image
    """
    x = data.astype('float64')
    (l10, l20) = x.shape

    (n1, n2) = int(ceil(log2(l10))), int(ceil(log2(l20)))
    l1, l2 = 2**n1, 2**n2

    if ( logical_or(l1>l10,l2>l20) ):
        x = zeros((l1,l2),dtype='float64')
        x[:l10,:l20] = data

    x0 = x.mean()
    xm_in = empty((l1,l2),dtype='float64'); xm_int = xm_in.T
    xm1 = empty((l1,l2),dtype='float64'); xm1t = xm1.T

    tlt = 2*log(2)*thresh_fac**2

    cx = empty((l1,l2),dtype='float64')
    cx = (x-x0).cumsum(axis=0).cumsum(axis=1)

    xnoise = zeros((l1,l2),dtype='float64')
    xnoise0 = zeros((l1,l2),dtype='float64')

    #
    # the data are prepared, now do the work
    #

    for l in xrange(n1):
        # transform in x, creating xm_in
        sclx = 2**l

        transform(cx,xm_in,sclx)

        xnoise0[:]=0.
        for m in xrange(n2):
            scly = 2**m

            transform(xm_int,xm1t,scly)

            # zero the significant elements of the transformed data, so that the insignificant part can later be subtracted away
            thresh = tlt * ( n1 + n2 - l - m - 2 )
            xm1[xm1**2>=thresh] = 0

            # now do the reverse transformation
            transform(xm1t[::-1].cumsum(axis=0),xm1t,scly)
            xnoise0 += xm1/(2*scly)**2

        transform(xnoise0[::-1].cumsum(axis=0),xnoise0,sclx)
        xnoise += xnoise0/(2*sclx)**2


    x[::-1,::-1] -= xnoise

    return x[:l10,:l20]


if __name__ == '__main__':
    """
    """
    if (len(sys.argv)<2): usage()

    img=sys.argv[1]
    if (os.path.exists(img)==False): usage()

    data = pyfits.getdata(img)
    hdr = pyfits.getheader(img)

    sdata = haar_denoise_2d(data)

    os.remove(img)
    pyfits.writeto(img,sdata,hdr)
