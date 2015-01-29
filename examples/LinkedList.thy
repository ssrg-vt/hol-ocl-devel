(*****************************************************************************
 * Featherweight-OCL --- A Formal Semantics for UML-OCL Version OCL 2.5
 *                       for the OMG Standard.
 *                       http://www.brucker.ch/projects/hol-testgen/
 *
 * LinkedList.thy --- OCL Contracts and Example drawn from 
 *                     "A Specification-Based Test Case Generation Method for UML/OCL"
 *                     (Brucker, Krieger, Longuet, and  Wolff)
 *
 * This file is part of HOL-TestGen.
 *
 * Copyright (c) 2013-2015 Université Paris-Sud, France
 *               2013-2015 IRT SystemX, France
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *
 *     * Neither the name of the copyright holders nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************)
(* $Id:$ *)

header{* Part ... *}

theory
  LinkedList
imports
  "../src/UML_OCL"
  (* separate compilation : UML_OCL *)
begin

Class Node
  Attributes i       : Integer
             "next"  : Node
End

Class List
  Attributes content : Node
End

Instance n1 :: Node = [ i = 2, "next" = n2 ]
     and n1':: Node = [ i = 2, "next" = n3 ]
     and n2 :: Node = [ i = 5 (*, "next" = null *) ]   (* problem with syntax *)
     and n3 :: Node = [ i = 3, "next" = n2 ]
     and l1 :: List = [ content = n1 ]
     and l1' :: List = [ content = n1' ]

Define_state \<sigma>\<^sub>1 = [ defines [ n1, n2, l1 ] ]
  

Define_state \<sigma>\<^sub>1' = [ defines [ n1', n2, n3, l1' ] ]

Define_pre_post  \<sigma>\<^sub>1 \<sigma>\<^sub>1'

Context Node 
  Inv asc : "self .next <> null implies (self .i  \<le>\<^sub>i\<^sub>n\<^sub>t self .next .i) "

Context Node :: contents() : Set(Integer)
  Post : "result \<triangleq> if (self .next \<doteq> null)
                   then (Set{}->including\<^sub>S\<^sub>e\<^sub>t(self .i))
                   else (self .next .contents() ->including\<^sub>S\<^sub>e\<^sub>t(self .i))
                   endif"

Context List :: insert(x:Integer) : Void
  Post : "if (self .content \<doteq> null) 
          then self .content .contents() \<triangleq> Set{x}
          else self .content .contents() \<triangleq> (self .content@pre .contents@pre())
          endif"

lemmas [simp,code_unfold] = dot_accessor

end