#pragma once
#ifndef OPENGM_LEARNABLE_FEATURE_FUNCTION_HXX
#define OPENGM_LEARNABLE_FEATURE_FUNCTION_HXX

#include <algorithm>
#include <vector>
#include <cmath>

#include "opengm/opengm.hxx"
#include "opengm/functions/function_registration.hxx"
#include "opengm/functions/function_properties_base.hxx"

namespace opengm {

/// Learnable feature function for two variables
///
/// f(x) = w * A(x) * feat
///  - w    = parameter vector
///  - feat = feature vector
///  - A    = assignment matrix variant to the labeling x
///
/// derive from this class and implement the function
///   paramaterGradient(i,x)= A(x)_{i,*}*feat
///  
/// \ingroup functions
template<class T, class I = size_t, class L = size_t>
class LearnableFeatureFunction
: public FunctionBase<LearnableFeatureFunction<T, I, L>, T, I, L>
{
public:
   typedef T ValueType;
   typedef L LabelType;
   typedef I IndexType;

   LearnableFeatureFunction(
      const opengm::learning::Weights<T>& parameters,
      const std::vector<L>& shape,
      const std::vector<size_t>& parameterIDs,
      const std::vector<T>& feat
      );
   L shape(const size_t) const;
   size_t size() const;
   size_t dimension() const;
   template<class ITERATOR> T operator()(ITERATOR) const;
 
   // parameters
   size_t numberOfWeights()const
     {return parameterIDs_.size();}
   I weightIndex(const size_t paramNumber) const
     {return parameterIDs_[paramNumber];} //dummy
   template<class ITERATOR> 
   T paramaterGradient(size_t,ITERATOR) const;

protected:
   const opengm::learning::Weights<T> * parameters_;
   const std::vector<L> shape_;
   const std::vector<size_t> parameterIDs_;
   const std::vector<T> feat_;


friend class FunctionSerialization<LearnableFeatureFunction<T, I, L> > ;
};


template<class T, class I, class L>
struct FunctionRegistration<LearnableFeatureFunction<T, I, L> > {
   enum ID {
      Id = opengm::FUNCTION_TYPE_ID_OFFSET + 100 + 64
   };
};

template <class T, class I, class L>
inline
LearnableFeatureFunction<T, I, L>::LearnableFeatureFunction
( 
   const opengm::learning::Weights<T>& parameters,
   const std::vector<L>& shape,
   const std::vector<size_t>& parameterIDs,
   const std::vector<T>& feat
   )
   :  parameters_(&parameters), shape_(shape), parameterIDs_(parameterIDs),feat_(feat)
{}

template <class T, class I, class L>
template <class ITERATOR>
inline T
LearnableFeatureFunction<T, I, L>::paramaterGradient
(
   size_t parameterNumber,
   ITERATOR begin
) const {
   OPENGM_ASSERT(parameterNumber< numberOfWeights());
   return 0; // need to be implemented
}


template <class T, class I, class L>
template <class ITERATOR>
inline T
LearnableFeatureFunction<T, I, L>::operator()
(
   ITERATOR begin
) const {
   T val = 0;
   for(size_t i=0;i<numberOfWeights();++i){
      val += parameters_->getWeight(i) * paramaterGradient(i,begin);
   }
}


template <class T, class I, class L>
inline L
LearnableFeatureFunction<T, I, L>::shape
(
   const size_t i
) const {
   return shape_[i];
}

template <class T, class I, class L>
inline size_t
LearnableFeatureFunction<T, I, L>::dimension() const {
   return shape_.size();
}

template <class T, class I, class L>
inline size_t
LearnableFeatureFunction<T, I, L>::size() const {
   size_t s = 1;
   for(size_t i=0;i<dimension(); ++i)
      s *= shape(i);
   return s;
}





} // namespace opengm

#endif // #ifndef OPENGM_LEARNABLE_FUNCTION_HXX
