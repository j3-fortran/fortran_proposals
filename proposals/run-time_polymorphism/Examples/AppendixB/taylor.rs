// Rust implementation of the Taylor series example program based on
// subtyping given in Appendix B of the proposal "Improved run-time
// polymorphism for Fortran".
//

pub mod interfaces {

    pub trait IDeriv {
        fn deriv1(&self);
    }

    pub trait IHDeriv {
        fn deriv1(&self);
        fn deriv2(&self);
    }
}

pub mod derivs {
    
    use interfaces::IDeriv;
    use interfaces::IHDeriv;
    
    pub struct DerivF {
    }    
    impl IDeriv for DerivF {
        fn deriv1(&self) {
      	    println!(" 1st derivative of function F!");
        }
    }    

    pub struct HDerivF {
    }    
    impl IHDeriv for HDerivF {
        fn deriv1(&self) {
      	    println!(" 1st derivative of function F!");
        }
        fn deriv2(&self) {
	    println!(" 2nd derivative of function F!");
        }
    }
    
    pub struct DerivG {
    }    
    impl IDeriv for DerivG {
        fn deriv1(&self) {
      	    println!(" 1st derivative of function G!");
        }
    }

    pub struct HDerivG {
    }    
    impl IHDeriv for HDerivG {
        fn deriv1(&self) {
      	    println!(" 1st derivative of function G!");
        }
        fn deriv2(&self) {
	    println!(" 2nd derivative of function G!");
        }
    }
}

pub mod series {

    use interfaces::IDeriv;
    use interfaces::IHDeriv;
    
    pub struct Taylor {
        pub calc: Box<dyn IDeriv>
    }
    impl Taylor {
        pub fn term1(&self) {
	    self.calc.deriv1();
        }
        pub fn evaluate(&self) {
	    println!("Evaluating Taylor series using");
	    self.term1();
        }
    }
    
    pub struct HTaylor {
        pub calc: Box<dyn IHDeriv>
    }           
    impl HTaylor {
        pub fn term1(&self) {
	    self.calc.deriv1();
        }
        pub fn term2(&self) {
	    self.calc.deriv2();
        }
        pub fn evaluate(&self) {
	    println!("Evaluating Taylor series using");
	    self.term1();
	    self.term2();
        }
    }
}

fn main() {

    use derivs::DerivG;
    use derivs::HDerivG;

    use series::Taylor;
    use series::HTaylor;    

    let derivg = Box::new( DerivG{} );
    let eval   = Box::new( Taylor{calc: derivg} );
    eval.evaluate();
    
    println!("");

    let hderivg = Box::new( HDerivG{} );
    let heval   = Box::new( HTaylor{calc: hderivg} );
    heval.evaluate();
    
}
