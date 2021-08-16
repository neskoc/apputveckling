package helloWorld;

import java.util.Arrays;

public class HelloWorld {
	
	public static int log2(int a)
	{
		// calculate log2 for a (integer)
	    return (int) (Math.log(a) / Math.log(2));
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		float[][] d = { { 1, 2, 3, 4 }, { 5, 6, 7, 8 }, { 17, 18, 19, 20 }, { 9, 10, 11, 12 } };
        Matrix D = new Matrix(d);
        System.out.println("Matrix D:");
        D.show();
        
		float[][] filter = { { 1, 1 }, { 1, 1 } };
        Matrix filterMatrix = new Matrix(filter);
        System.out.println("Filter:");
        filterMatrix.show();
        System.out.println();

        System.out.println("convWithStride:");
        Matrix C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        filter = new float[][] { { 1, 1 }, { -1, -1 } };
        filterMatrix = new Matrix(filter);
        System.out.println("Filter 2:");
        filterMatrix.show();
        System.out.println();

        System.out.println("convWithStride:");
        C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        filter = new float[][] { { 1, -1 }, { 1, -1 } };
        filterMatrix = new Matrix(filter);
        System.out.println("Filter 3:");
        filterMatrix.show();
        System.out.println();

        System.out.println("convWithStride:");
        C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        filter = new float[][] { { 1, -1 }, { -1, 1 } };
        Matrix filterMatrix4 = new Matrix(filter);
        System.out.println("Filter 4:");
        filterMatrix4.show();
        System.out.println();

        System.out.println("convWithStride:");
        C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        System.out.println("ConcatV Filter 3 and 4:");
        C = filterMatrix.concatV(filterMatrix4);
        C.show();
        System.out.println();

        System.out.println("ConcatH Filter 3 and 4:");
        C = filterMatrix.concatH(filterMatrix4);
        C.show();
        System.out.println();

        System.out.println("Reduce Matrix:");
        Matrix reduced = D.reduce(2,2);
        reduced.show();
        System.out.println();

        System.out.println("Expand Matrix:");
        Matrix expanded = D.expand(8, 16);
        expanded.show();
        System.out.println();

        System.out.println("Expand Matrix from array:");
        float[] array = D.toArray();
	    Matrix X = Matrix.array2Matrix(array, 4, 4).expand(6,8);
	    X.show();
	    array = X.toArray();
	    X = Matrix.array2Matrix(array, 8, 6);
        System.out.println("X.length:" + X.getData().length + " : " + X.getData()[0].length);
        System.out.println();

        System.out.println("copy of D:");
        Matrix Copied = new Matrix(10,10);
        Copied.copy(D);
        Copied.show();
        System.out.println();

        System.out.println("Crop Matrix D:");
        Matrix cropped = D.crop(2, 2, 1, 2);
        cropped.show();
        System.out.println();
        

		int lev_rows = log2(10);
	    int lev_cols = log2(12);
	    int mm = (int) Math.pow(2, lev_rows);
	    int nn = (int) Math.pow(2, lev_cols);
	    int level = 2;

	    int mw = mm / (int) Math.pow(2, level);
	    int nw = nn /  (int) Math.pow(2, level);

	    Matrix w1 = expanded.reduce(mw, nw);
	    Matrix w2 = expanded.crop(mw, nw, nw, 0);
	    Matrix w3 = expanded.crop(mw, nw, 0, mw);
	    Matrix w4 = expanded.crop(mw, nw, nw, mw);
	    w1.show();
        System.out.println();
	    w2.show();
        System.out.println();
	    w3.show();
        System.out.println();
	    w4.show();
        System.out.println();
        
//        float[] tmpArr = new float[2];
//        System.arraycopy(d[1], 1, tmpArr, 0, 2);
//        for (int j = 0; j < tmpArr.length; j++) 
//            System.out.printf("%9.4f ", tmpArr[j]);
//        System.out.println();
//
//        System.out.println("Random matrix A:");
//        Matrix A = Matrix.random(5, 5);
//        A.show();
//        System.out.println();
//
//        System.out.println("A swap 1<->2:");
//        A.swap(1, 2);
//        A.show();
//        System.out.println();
//
//        System.out.println("B = A.T:");
//        Matrix B = A.transpose();
//        B.show();
//        System.out.println();
//
//        System.out.println("Identity matrix C:");
//        Matrix C = Matrix.identity(5);
//        C.show(); 
//        System.out.println();
//
//        System.out.println("A + B:");
//        A.plus(B).show();
//        System.out.println();
//
//        System.out.println("B*A:");
//        B.times(A).show();
//        System.out.println();
//
//        System.out.println("D.*D:");
//        D.dotTimes(D).show();
//        System.out.println();
//
//        // shouldn't be equal since AB != BA in general
//
//        System.out.println("(AB == BA)?");
//        System.out.println(A.times(B).eq(B.times(A)));
//        System.out.println();
//
//        System.out.println("Random matrix b(5,1):");
//        Matrix b = Matrix.random(5, 1);
//        b.show();
//        System.out.println();
//
//        System.out.println("Solve xA=b:");
//        Matrix x = A.solve(b);
//        x.show();
//        System.out.println();
//
//        System.out.println("A*x:");
//        A.times(x).show();

	}
}
