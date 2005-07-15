#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_newRV_noinc
#include "ppport.h"

#include "TreeNode.h"

/*

   Since an IV is large enough to hold a pointer (see <perlguts>), we
   use that to store the new node information.

*/

#define SV2NODE(S) (Node*) SvIV(SvRV(S))

MODULE = Tree::Node PACKAGE = Tree::Node

PROTOTYPES: ENABLE

SV*
new(package, child_count)
    char *package
    int  child_count
  PROTOTYPE: $$
  CODE:
    Node* self = new(child_count);
    SV*   n    = newSViv((IV) self);
    RETVAL     = newRV_noinc(n);
    sv_bless(RETVAL, gv_stashpv(package, 0));
#    SvREADONLY_on(n);
  OUTPUT:
    RETVAL

void
DESTROY(n)
    SV* n
  PROTOTYPE: $
  CODE:
    Node* self = SV2NODE(n);
    DESTROY(self);

int
MAX_LEVEL()
  PROTOTYPE:
  CODE:
    RETVAL = MAX_LEVEL;
  OUTPUT:
    RETVAL

int
_allocated_by_child_count(count)
    int count
  PROTOTYPE: $
  CODE:
    RETVAL = SIZE(count);
  OUTPUT:
    RETVAL

int
_allocated(n)
    SV* n
  PROTOTYPE: $
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = _allocated(self);
  OUTPUT:
    RETVAL

void
_increment_child_count(n)
    SV* n
  PROTOTYPE: $
  CODE:
    Node* clone;
    Node* self = SV2NODE(n);
    int   count = child_count(self);
    if (count == MAX_LEVEL)
      croak("cannot add another child: we have %d children", count);
    clone = (Node*) realloc(self, SIZE(count+1));
    if (clone == NULL)
      croak("cannot add another child: realloc failed");
#    SvREADONLY_off(n);
    sv_setiv((SV*)SvRV(n), clone);
#    SvREADONLY_on(n);
    clone->child_count++;
    clone->next[count] = &PL_sv_undef;

void
_rotate_children(n, bottom)
    SV* n
    int bottom
  PROTOTYPE: $$
  CODE:
    Node* self = SV2NODE(n);
    SV* tmp;
    int count = child_count(self);
    if (bottom >= count)
      croak("bottom %d cannot exceed child count %d", bottom, count);
    if (count>(bottom+1)) {
      tmp = self->next[count-1];
      while (count-- > bottom)
        self->next[count] = self->next[count-1];
      self->next[bottom] = tmp;    
    }

int
child_count(n)
    SV* n
  PROTOTYPE: $
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = child_count(self);
  OUTPUT:
    RETVAL

SV*
get_child(n, index)
    SV* n
    int index
  PROTOTYPE: $$
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = get_child(self, index);
  OUTPUT:
    RETVAL

SV*
get_child_or_undef(n, index)
    SV* n
    int index
  PROTOTYPE: $$
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = get_child_or_undef(self, index);
  OUTPUT:
    RETVAL

void
set_child(n, index, t)
    SV* n
    int index
    SV* t
  PROTOTYPE: $$$
  CODE:
    Node* self = SV2NODE(n);
    set_child(self, index, t);


void
set_key(n, k)
    SV* n
    SV* k
  PROTOTYPE: $$
  CODE:
    Node* self = SV2NODE(n);
    set_key(self, k);

SV*
key(n)
    SV* n
  PROTOTYPE: $
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = get_key(self);
  OUTPUT:
    RETVAL

I32
key_cmp(n, k)
    SV* n
    SV* k
  PROTOTYPE: $$
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = key_cmp(self, k);
  OUTPUT:
    RETVAL

void
set_value(n, v)
    SV* n
    SV* v
  PROTOTYPE: $$
  CODE:
    Node* self = SV2NODE(n);
    set_value(self, v);

SV*
value(n)
    SV* n
  PROTOTYPE: $
  CODE:
    Node* self = SV2NODE(n);
    RETVAL = get_value(self);
  OUTPUT:
    RETVAL

