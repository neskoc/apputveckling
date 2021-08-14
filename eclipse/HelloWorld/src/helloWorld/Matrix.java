/**
 * 
 */
package helloWorld;

import java.util.Arrays;
import java.lang.Math;

/**
 * @author nesko
 * 
 * Base Matrix class comes from
 * Robert Sedgewick and Kevin Wayne.
 * 
 * Added methods:
 * dotTimes - elementwise multiplication
 * convWithStride(A, B, stride) - convolution of A with B using stride
 */

final public class Matrix {
    private final int m;             // number of rows
    private final int n;             // number of columns
    private final double[][] data;   // m-by-n array

    // create m-by-n matrix of 0's
    public Matrix(int m, int n) {
        this.m = m;
        this.n = n;
        data = new double[m][n];
    }

    // create matrix based on 2d array
    public Matrix(double[][] data) {
        m = data.length;
        n = data[0].length;
        this.data = new double[m][n];
        for (int i = 0; i < m; i++)
        	this.data[i] = data[i];
    }
    
    public int[] getDimensions() {
    	return new int[] {this.m, this.n};
    }
    
    public Matrix reduce(int m, int n) {
    	double[][] reduced = new double[m][n];
    	double[][] x = this.getData();
    	for (int i = 0; i < m; i++)
    		System.arraycopy(x[i], 0, reduced[i], 0, n);
    	return new Matrix(reduced);
    }
    
    public double[][] getData() {
    	return this.data;
    }
    
    public double sum() {
        double	sum = 0.0;
        for (int i = 0; i < m; i++)
        	for (int j = 0; j < n; j++)
        		sum += this.data[i][j];
    	return sum;
    }
	
	public double std2()
    {
        double	sum = 0.0, 
        		standardDeviation = 0.0;
       int size = this.m * this.n;

        sum = sum();
        double mean = sum / size;

        for (int i = 0; i < m; i++)
        	for (int j = 0; j < n; j++)
        		standardDeviation += Math.pow(this.data[i][j] - mean, 2);
        return Math.sqrt(standardDeviation / size);
    }

	public double[] toArray() {
		double[] array = new double[m * n];
		for(int i = 0; i < m; i++)
			System.arraycopy(this.data[i], 0, array, (i * n), n);
		return array;
	}
	
	public double median()
	{
		int size = this.m * this.n;
		double res = 0.0;
		double[] array = this.toArray();
		Arrays.sort(array);
		
		if (size % 2 == 1)
			res = array[((size + 1) / 2) - 1];
		else
			res = (array[n/2 - 1] + array[n/2]) / 2;
		return res;
	}
	
	public Matrix abs() {
		double[][] res = new double[m][n];
		for (int i = 0; i < m; i++)
        	for (int j = 0; j < n; j++)
        		res[i][j] = Math.abs(this.data[i][j]);
		return new Matrix(res);
	}

    // copy constructor
    private Matrix(Matrix A) {
    	this(A.data);
    }

    // create and return a random m-by-n matrix with values between 0 and 1
    public static Matrix random(int m, int n) {
        Matrix A = new Matrix(m, n);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                A.data[i][j] = Math.random();
        return A;
    }

    // create and return the n-by-n identity matrix
    public static Matrix identity(int n) {
        Matrix I = new Matrix(n, n);
        for (int i = 0; i < n; i++)
            I.data[i][i] = 1;
        return I;
    }

    // swap rows i and j
    public void swap(int i, int j) {
        double[] temp = data[i];
        data[i] = data[j];
        data[j] = temp;
    }

    // create and return the transpose of the invoking matrix
    public Matrix transpose() {
        Matrix A = new Matrix(n, m);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                A.data[j][i] = this.data[i][j];
        return A;
    }

    // return C = A + B
    public Matrix plus(Matrix B) {
        Matrix A = this;
        if (B.m != A.m || B.n != A.n) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(m, n);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                C.data[i][j] = A.data[i][j] + B.data[i][j];
        return C;
    }

    // return C = concatenated arrays A and B vertically
    public Matrix concatV(Matrix B) {
        Matrix A = this;
        if (B.n != A.n) throw new RuntimeException("Illegal matrix dimensions. Matrix B.n != A.n");
        Matrix C = new Matrix(A.m + B.m, A.n);
        for (int i = 0; i < A.m; i++)
                C.data[i] = A.data[i];
        for (int i = 0; i < B.m; i++)
            C.data[A.m + i] = B.data[i];
        return C;
    }

    // return C = concatenated arrays A and B horizontally
    public Matrix concatH(Matrix B) {
        Matrix A = this;
        if (B.m != A.m) throw new RuntimeException("Illegal matrix dimensions. Matrix B.m != A.m");
        double[][] c = new double[A.n][A.m + B.m];
        double[][] a = A.getData();
        double[][] b = B.getData();
        for (int i = 0; i < A.m; i++)
        	System.arraycopy(a[i], 0, c[i], 0, A.n);
        for (int i = 0; i < B.m; i++)
        	System.arraycopy(b[i], 0, c[i], A.n, B.n);
        return new Matrix(c);
    }


    // return C = A - B
    public Matrix minus(Matrix B) {
        Matrix A = this;
        if (B.m != A.m || B.n != A.n) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(m, n);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                C.data[i][j] = A.data[i][j] - B.data[i][j];
        return C;
    }

    // does A = B exactly?
    public boolean eq(Matrix B) {
        Matrix A = this;
        if (B.m != A.m || B.n != A.n) throw new RuntimeException("Illegal matrix dimensions.");
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                if (A.data[i][j] != B.data[i][j]) return false;
        return true;
    }

    // return C = A * B
    public Matrix times(Matrix B) {
        Matrix A = this;
        if (A.n != B.m) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(A.m, B.n);
        for (int i = 0; i < C.m; i++)
            for (int j = 0; j < C.n; j++)
                for (int k = 0; k < A.n; k++)
                    C.data[i][j] += (A.data[i][k] * B.data[k][j]);
        return C;
    }

    // return C = A .* B (element wise multiplication of matrixes)
    public Matrix dotTimes(Matrix B) {
        Matrix A = this;
        if (A.n != B.n || A.m != B.m) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(A.m, A.n);
        for (int i = 0; i < C.m; i++)
            for (int j = 0; j < C.n; j++)
            	C.data[i][j] += (A.data[i][j] * B.data[i][j]);
        return C;
    }
    
    // return C = A.convWithStride(B), B is square matrix
    // stride is equal do dimension of B
    public Matrix convWithStride(Matrix B) {
    	int mm, nn;
        int stride = B.n;
        double partSum;
        Matrix A = this;
        if (B.n != B.m) throw new RuntimeException("B must be square matrix!");
        if (A.n % B.n != 0 || A.m % B.m != 0) throw new RuntimeException("Illegal matrix dimensions.");
        mm = A.m / B.m;
        nn = A.n / B.n;
        Matrix C = new Matrix(mm, nn);
        for (int i = 0; i < mm; i++)
            for (int j = 0; j < nn; j++) {
        		partSum = 0;
            	for(int k = i*stride; k < (i+1)*stride; k++)
            		for(int l = j*stride; l < (j+1)*stride; l++)
            			partSum += A.data[k][l] * B.data[k%stride][l%stride];
                C.data[i][j] += partSum;
            }
        return C;
    }


    // return x = A^-1 b, assuming A is square and has full rank
    public Matrix solve(Matrix rhs) {
        if (m != n || rhs.m != n || rhs.n != 1)
            throw new RuntimeException("Illegal matrix dimensions.");

        // create copies of the data
        Matrix A = new Matrix(this);
        Matrix b = new Matrix(rhs);

        // Gaussian elimination with partial pivoting
        for (int i = 0; i < n; i++) {

            // find pivot row and swap
            int max = i;
            for (int j = i + 1; j < n; j++)
                if (Math.abs(A.data[j][i]) > Math.abs(A.data[max][i]))
                    max = j;
            A.swap(i, max);
            b.swap(i, max);

            // singular
            if (A.data[i][i] == 0.0) throw new RuntimeException("Matrix is singular.");

            // pivot within b
            for (int j = i + 1; j < n; j++)
                b.data[j][0] -= b.data[i][0] * A.data[j][i] / A.data[i][i];

            // pivot within A
            for (int j = i + 1; j < n; j++) {
                double m = A.data[j][i] / A.data[i][i];
                for (int k = i+1; k < n; k++) {
                    A.data[j][k] -= A.data[i][k] * m;
                }
                A.data[j][i] = 0.0;
            }
        }

        // back substitution
        Matrix x = new Matrix(n, 1);
        for (int j = n - 1; j >= 0; j--) {
            double t = 0.0;
            for (int k = j + 1; k < n; k++)
                t += A.data[j][k] * x.data[k][0];
            x.data[j][0] = (b.data[j][0] - t) / A.data[j][j];
        }
        return x;
   
    }

    // print matrix to standard output
    public void show() {
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) 
                System.out.printf("%9.4f ", data[i][j]);
            System.out.println();
        }
    }
}