! Fortran implementation of the Taylor series example program based on
! subtyping given in Appendix B of the proposal "Improved run-time
! polymorphism for Fortran".
!

module interfaces

   abstract interface :: IDeriv
      subroutine deriv1()
      end subroutine deriv1
   end interface

   abstract interface, extends(IDeriv) :: IHDeriv
      subroutine deriv2()
      end subroutine deriv2
   end interface IHDeriv

end module interfaces
   
module derivs

   use interfaces, only: IDeriv, IHDeriv
   
   type, implements(IDeriv) :: DerivF
   contains
      procedure, nopass :: deriv1 => deriv1f
   end type DerivF

   type, implements(IHDeriv) :: HDerivF
   contains
      procedure, nopass :: deriv1 => deriv1f
      procedure, nopass :: deriv2 => deriv2f
   end type HDerivF
   
   type, implements(IDeriv) :: DerivG
   contains
      procedure, nopass :: deriv1 => deriv1g
   end type DerivG

   type, implements(IHDeriv) :: HDerivG
   contains
      procedure, nopass :: deriv1 => deriv1g
      procedure, nopass :: deriv2 => deriv2g
   end type HDerivG
   
contains

   subroutine deriv1f()
      write(*,*) " 1st derivative of function F!"
   end subroutine deriv1f

   subroutine deriv2f()
      write(*,*) " 2nd derivative of function F!"
   end subroutine deriv2f
   
   subroutine deriv1g()
      write(*,*) " 1st derivative of function G!"
   end subroutine deriv1g
   
   subroutine deriv2g()
      write(*,*) " 2nd derivative of function G!"
   end subroutine deriv2g

end module derivs

module series

   use interfaces, only: IDeriv, IHDeriv

   type :: Taylor
      class(IDeriv), allocatable :: calc
   contains
      procedure :: term1
      procedure :: evaluate
   end type Taylor
   
   type :: HTaylor
      class(IHDeriv), allocatable :: calc
   contains
      procedure :: term1    => hterm1
      procedure :: term2    => hterm2
      procedure :: evaluate => hevaluate
   end type HTaylor
 
contains

    subroutine term1(self)
       class(Taylor), intent(in) :: self
       call self%calc%deriv1()
    end subroutine term1
    
    subroutine evaluate(self)
       class(Taylor), intent(in) :: self
       write(*,*) 'Evaluating Taylor series using'
       call self%term1()
    end subroutine evaluate

    subroutine hterm1(self)
       class(HTaylor), intent(in) :: self
       call self%calc%deriv1()
    end subroutine hterm1
    
    subroutine hterm2(self)
       class(HTaylor), intent(in) :: self
       call self%calc%deriv2()
    end subroutine hterm2

    subroutine hevaluate(self)
       class(HTaylor), intent(in) :: self
       write(*,*) 'Evaluating Taylor series using'
       call self%term1()
       call self%term2()
    end subroutine hevaluate

end module series
 
program client

   use derivs, only: DerivG, HDerivG
   use series, only: Taylor, HTaylor
   
   type(Taylor),  allocatable :: teval
   type(HTaylor), allocatable :: hteval
   
   teval = Taylor( DerivG() )
   call teval%evaluate()

   write(*,*)

   hteval = HTaylor( HDerivG() )
   call hteval%evaluate()
   
end program client
