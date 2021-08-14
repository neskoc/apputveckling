package helloWorld;

public class HelloWorld {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		double[][] d = { { 1, 2, 3, 4 }, { 5, 6, 7, 8 }, { 17, 18, 19, 20 }, { 9, 10, 11, 12 } };
        Matrix D = new Matrix(d);
        System.out.println("Matrix D:");
        D.show();
        
		double[][] filter = { { 1, 1 }, { 1, 1 } };
        Matrix filterMatrix = new Matrix(filter);
        System.out.println("Filter:");
        filterMatrix.show();
        System.out.println();
        
        Matrix C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        filter = new double[][] { { 1, 1 }, { -1, -1 } };
        filterMatrix = new Matrix(filter);
        System.out.println("Filter 2:");
        filterMatrix.show();
        System.out.println();
        
        C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        filter = new double[][] { { 1, -1 }, { 1, -1 } };
        filterMatrix = new Matrix(filter);
        System.out.println("Filter 3:");
        filterMatrix.show();
        System.out.println();
        
        C = D.convWithStride(filterMatrix);
        C.show();
        System.out.println();

        filter = new double[][] { { 1, -1 }, { -1, 1 } };
        Matrix filterMatrix4 = new Matrix(filter);
        System.out.println("Filter 4:");
        filterMatrix4.show();
        System.out.println();
        
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
        
//        double[] tmpArr = new double[2];
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
