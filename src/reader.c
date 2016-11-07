// ======
// Reader
// ======
//
// .. code-block:: cpp
//
#include "reader.h"

#include "chirp.h"
#include "connection.h"

char str[] = 
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n"
"a as sd fsd fasdf asd fa d afsdfas df asdf as df asdf sdf as\n";

// .. c:function::
void
ch_rd_read(ch_connection_t* conn, void* buf, size_t read)
//    :noindex:
//
//    see: :c:func:`ch_rd_read`
//
// .. code-block:: cpp
//
{
    // TODO excpect partial reads
    ch_chirp_t* chirp = conn->chirp;
    A(chirp->_init == CH_CHIRP_MAGIC, "Not a ch_chirp_t*");
    ch_chirp_int_t* ichirp = chirp->_;
    ch_reader_t* reader = &conn->reader;
    printf("%s", (char*) buf);
    switch(reader->state) {
        case CH_RD_START:
            reader->hs.port = ichirp->public_port;
            reader->hs.max_timeout = (
                (ichirp->config.RETRIES + 2) * ichirp->config.TIMEOUT
            );
            memcpy(reader->hs.identity, ichirp->identity, 16);
            //ch_cn_write(conn, &reader->hs, sizeof(ch_rd_handshake_t), NULL);
            ch_cn_write(conn, str, sizeof(str), NULL);
            break;
        default:
            A(0, "Unknown reader state");
    }
}
