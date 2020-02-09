! Fortran implementation of the Taylor series example program based on
! subclassing given in Appendix A of the proposal "Improved run-time
! polymorphism for Fortran".
!

module derivs

   type, abstract :: Deriv
   contains
      procedure(pderiv), deferred, nopass ::  deriv1
   end type Deriv

   abstract interface
      subroutine pderiv()
      end subroutine pderiv      
   end interface
   
   type, extends(Deriv) :: DerivF
   contains
      procedure, nopass :: deriv1 => deriv1f
   end type DerivF

   type, extends(DerivF) :: HDerivF
   contains
      procedure, nopass :: deriv2 => deriv2f
   end type HDerivF

   type, extends(Deriv) :: DerivG
   contains
      procedure, nopass :: deriv1 => deriv1g
   end type DerivG

   type, extends(DerivG) :: HDerivG
   contains
      procedure, nopass :: deriv2 => deriv2g
   end type HDerivG
   
contains

   subroutine deriv1f()
      write(*,*) ' 1st derivative of function F!'
   end subroutine deriv1f

   subroutine deriv2f()
      write(*,*) ' 2nd derivative of function F!'
   end subroutine deriv2f

   subroutine deriv1g()
      write(*,*) ' 1st derivative of function G!'
   end subroutine deriv1g

   subroutine deriv2g()
      write(*,*) ' 2nd derivative of function G!'
   end subroutine deriv2g

end module derivs

module series

   use derivs, only: Deriv, HDerivF, HDerivG

   type :: Taylor
      class(Deriv), allocatable :: calc
   contains
      procedure :: term1
      procedure :: evaluate
   end type Taylor

   type, extends(Taylor) :: HTaylor
   contains
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
      
   subroutine hterm2(self)
      class(HTaylor), intent(in) :: self
      select type ( calc => self%calc )
      class is ( HDerivF )
         call calc%deriv2()
      class is ( HDerivG )
         call calc%deriv2()
      class default
         write(*,*) 'Unknown type!'
      end select
   end subroutine hterm2

   subroutine hevaluate(self)
      class(HTaylor), intent(in) :: self
      write(*,*) 'Evaluating Taylor series using'
      call self%term1()
      call self%term2()
   end subroutine hevaluate

end module series

program client

   use derivs, only: DerivG, HDerivG, Deriv
   use series, only: Taylor, HTaylor

   class(Deriv),  allocatable :: derv
   class(Taylor), allocatable :: teval
   
   derv  = DerivG()
   teval = Taylor(derv)   
   call teval%evaluate()   

   write(*,*)
   
   derv  = HDerivG()
   teval = HTaylor(derv)
   call teval%evaluate()   

end program client
