// Java implementation of the Taylor series example program based on
// subtyping given in Appendix B of the proposal "Improved run-time
// polymorphism for Fortran".
//

interface IDeriv {
    void deriv1();
}

interface IHDeriv extends IDeriv {
    void deriv2();
}

class DerivF implements IDeriv {
    public void deriv1() {
      	System.out.println(" 1st derivative of function F!");
    }
}

class HDerivF implements IHDeriv {
    public void deriv1() {
      	System.out.println(" 1st derivative of function F!");
    }
    public void deriv2() {
	System.out.println(" 2nd derivative of function F!");
    }
}

class DerivG implements IDeriv {
    public void deriv1() {
      	System.out.println(" 1st derivative of function G!");
    }
}

class HDerivG implements IHDeriv {
    public void deriv1() {
      	System.out.println(" 1st derivative of function G!");
    }
    public void deriv2() {
	System.out.println(" 2nd derivative of function G!");
    }
}

class Taylor {
    IDeriv calc;
    Taylor(IDeriv calculator) {
	calc = calculator;
    }    
    public void term1() {
	calc.deriv1();
    }
    public void evaluate() {
	System.out.println("Evaluating Taylor series using");
	term1();
    }
}
   
class HTaylor {
    IHDeriv calc;
    HTaylor(IHDeriv calculator) {
	calc = calculator;
    }
    public void term1() {
	calc.deriv1();
    }
    public void term2() {
	calc.deriv2();
    }
    public void evaluate() {
	System.out.println("Evaluating Taylor series using");
	term1();
	term2();
    }
}

class ClientApp {

    public static void main(String[] args) {
	
	Taylor eval = new Taylor( new DerivG() );
	eval.evaluate();

	System.out.println("");
	
	HTaylor heval = new HTaylor( new HDerivG() );
	heval.evaluate();
    }
}
