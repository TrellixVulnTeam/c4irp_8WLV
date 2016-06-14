// ============
// Chirp Header
// ============
//
// .. code-block:: cpp

#ifndef ch_c4irp_h
#define ch_c4irp_h

#include "../include/c4irp_obj.h"
#include "protocol.h"

// .. c:type:: ch_chirp_int_t
//
//    Chirp object.
//  
//
//    .. c:member:: uv_async_t close
//
//       async handler to close c4irp on the main-loop
//
//    .. c:member:: int auto_start
//
//       true if we have to close the libuv loop, otherwise the loop was
//       supplied by the user
//
// .. code-block:: cpp
//
struct ch_chirp_int {
    int                      auto_start;
    uv_async_t               close;
    ch_protocol_t            protocol;
};

// .. c:function::
static void
_ch_on_new_connection(uv_stream_t *server, int status);
//
//  Callback from libuv on new connection
//
// .. code-block:: cpp

#endif //ch_c4irp_h
