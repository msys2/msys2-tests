-- This triggers an internal exception in the ada compiler
-- and makes sure exception handling works there
-- https://gcc.gnu.org/bugzilla/show_bug.cgi?id=109670
with GNAT.Spitbol.Patterns;
procedure gnat_exception_internal is
   M : GNAT.Spitbol.Patterns.Match_Result;
   type Header_Symbol is (None, Name, Attr, Conv, Prag);
begin
   null;
end gnat_exception_internal;