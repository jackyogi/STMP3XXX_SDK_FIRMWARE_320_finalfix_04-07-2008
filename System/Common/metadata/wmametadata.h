#ifndef _WMAMETADATA_H
#define _WMAMETADATA_H

#define WMA_HEADER_OBJECT_HEADER_SIZE 30

#define ASF_HEADER_GUID_0               0xb22630
#define ASF_HEADER_GUID_1               0x668e75
#define ASF_HEADER_GUID_2               0xa611cf
#define ASF_HEADER_GUID_3               0xaa00d9
#define ASF_HEADER_GUID_4               0xce6200
#define ASF_HEADER_GUID_5               0x00006c

#define ASF_FILE_PROPERTIES_GUID_0      0xabdca1
#define ASF_FILE_PROPERTIES_GUID_1      0xa9478c
#define ASF_FILE_PROPERTIES_GUID_2      0x8e11cf
#define ASF_FILE_PROPERTIES_GUID_3      0xc000e4
#define ASF_FILE_PROPERTIES_GUID_4      0x53200c
#define ASF_FILE_PROPERTIES_GUID_5      0x000065

#define ASF_STREAM_PROPERTIES_GUID_0    0xdc0791
#define ASF_STREAM_PROPERTIES_GUID_1    0xa9b7b7
#define ASF_STREAM_PROPERTIES_GUID_2    0x8e11cf
#define ASF_STREAM_PROPERTIES_GUID_3    0xc000e6
#define ASF_STREAM_PROPERTIES_GUID_4    0x53200c
#define ASF_STREAM_PROPERTIES_GUID_5    0x000065

#define ASF_STREAM_BITRATE_GUID_0       0xf875ce
#define ASF_STREAM_BITRATE_GUID_1       0x468d7b
#define ASF_STREAM_BITRATE_GUID_2       0x8d11d1
#define ASF_STREAM_BITRATE_GUID_3       0x600082
#define ASF_STREAM_BITRATE_GUID_4       0xa2c997
#define ASF_STREAM_BITRATE_GUID_5       0x0000b2

#define ASF_CONTENT_DESCRIPTION_GUID_0  0xb22633
#define ASF_CONTENT_DESCRIPTION_GUID_1  0x668e75
#define ASF_CONTENT_DESCRIPTION_GUID_2  0xa611cf
#define ASF_CONTENT_DESCRIPTION_GUID_3  0xaa00d9
#define ASF_CONTENT_DESCRIPTION_GUID_4  0xce6200
#define ASF_CONTENT_DESCRIPTION_GUID_5  0x00006c

#define ASF_EXTENDED_CONTENT_GUID_0     0xd0a440
#define ASF_EXTENDED_CONTENT_GUID_1     0xe307d2
#define ASF_EXTENDED_CONTENT_GUID_2     0x9711d2
#define ASF_EXTENDED_CONTENT_GUID_3     0xa000f0
#define ASF_EXTENDED_CONTENT_GUID_4     0xa85ec9
#define ASF_EXTENDED_CONTENT_GUID_5     0x000050

#define ASF_AUDIO_MEDIA_GUID_0          0x699e40
#define ASF_AUDIO_MEDIA_GUID_1          0x5b4df8
#define ASF_AUDIO_MEDIA_GUID_2          0xa811cf
#define ASF_AUDIO_MEDIA_GUID_3          0x8000fd
#define ASF_AUDIO_MEDIA_GUID_4          0x445c5f
#define ASF_AUDIO_MEDIA_GUID_5          0x00002b

#ifdef JANUS
#define ASF_CONTENT_ENCRYPTION_GUID_0  0x8ae614
#define ASF_CONTENT_ENCRYPTION_GUID_1  0x262229
#define ASF_CONTENT_ENCRYPTION_GUID_2  0xb94c17
#define ASF_CONTENT_ENCRYPTION_GUID_3  0xe0da35
#define ASF_CONTENT_ENCRYPTION_GUID_4  0x28e97e
#define ASF_CONTENT_ENCRYPTION_GUID_5  0x00009c
#endif


enum Descriptor_Value_Data_Type {
    TYPE_UNICODE,
    TYPE_BYTEARRAY,
    TYPE_BOOL,
    TYPE_DWORD,
    TYPE_QWORD,
    TYPE_WORD
};


RETCODE _reentrant GetWmaMetaData (INT PackedPathNameAddress, INT btCurrentDevice, FILE_META_DATA *MetaData);

#endif