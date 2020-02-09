module derivs
   type :: DerivF
   contains
      procedure, nopass :: deriv1 => deriv1f
   end type DerivF
contains
   subroutine deriv1f()
      write(*,*) ' 1st derivative of function F!'
   end subroutine deriv1f
end module derivs

module series
   use derivs, only: DerivF
   type :: Taylor
      type(DerivF), allocatable :: calc
   contains
      procedure :: term1
      procedure :: evaluate
   end type Taylor
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
end module series

program client
   use derivs, only: DerivF
   use series, only: Taylor
   type(Taylor), allocatable :: teval
   teval = Taylor( DerivF() )   
   call teval%evaluate()   
end program client
