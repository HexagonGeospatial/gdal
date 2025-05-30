/******************************************************************************
 *
 * Project:  GDAL ECW Driver
 * Purpose:  JP2UserBox implementation - arbitrary box read/write.
 * Author:   Frank Warmerdam, warmerdam@pobox.com
 *
 ******************************************************************************
 * Copyright (c) 2005, Frank Warmerdam <warmerdam@pobox.com>
 *
 * SPDX-License-Identifier: MIT
 ****************************************************************************/

// ncsjpcbuffer.h needs the min and max macros.
#undef NOMINMAX

#include "gdal_ecw.h"

#if defined(HAVE_COMPRESS)

/************************************************************************/
/*                             JP2UserBox()                             */
/************************************************************************/

JP2UserBox::JP2UserBox()
{
    pabyData = nullptr;
    nDataLength = 0;

    m_nTBox = 0;
}

/************************************************************************/
/*                            ~JP2UserBox()                             */
/************************************************************************/

JP2UserBox::~JP2UserBox()

{
    if (pabyData != nullptr)
    {
        CPLFree(pabyData);
        pabyData = nullptr;
    }
}

/************************************************************************/
/*                              SetData()                               */
/************************************************************************/

void JP2UserBox::SetData(int nLengthIn, const unsigned char *pabyDataIn)

{
    if (pabyData != nullptr)
        CPLFree(pabyData);

    nDataLength = nLengthIn;
    pabyData = static_cast<unsigned char *>(CPLMalloc(nDataLength));
    memcpy(pabyData, pabyDataIn, nDataLength);

    m_bValid = true;
}

/************************************************************************/
/*                            UpdateXLBox()                             */
/************************************************************************/

void JP2UserBox::UpdateXLBox()

{
    m_nXLBox = 8 + nDataLength;
    m_nLDBox = nDataLength;
}

/************************************************************************/
/*                               Parse()                                */
/*                                                                      */
/*      Parse box, and data contents from file into memory.             */
/************************************************************************/
#if ECWSDK_VERSION >= 55
CNCSError JP2UserBox::Parse(CPL_UNUSED NCS::SDK::CFileBase &JP2File,
                            CPL_UNUSED const NCS::CIOStreamPtr &Stream)
#elif ECWSDK_VERSION >= 40
CNCSError JP2UserBox::Parse(CPL_UNUSED NCS::SDK::CFileBase &JP2File,
                            CPL_UNUSED NCS::CIOStream &Stream)
#else
CNCSError JP2UserBox::Parse(CPL_UNUSED class CNCSJP2File &JP2File,
                            CPL_UNUSED CNCSJPCIOStream &Stream)
#endif
{
    CNCSError Error;

    return Error;
}

/************************************************************************/
/*                              UnParse()                               */
/*                                                                      */
/*      Write box meta information, and data to file.                   */
/************************************************************************/
#if ECWSDK_VERSION >= 55
CNCSError JP2UserBox::UnParse(NCS::SDK::CFileBase &JP2File,
                              const NCS::CIOStreamPtr &Stream)
#elif ECWSDK_VERSION >= 40
CNCSError JP2UserBox::UnParse(NCS::SDK::CFileBase &JP2File,
                              NCS::CIOStream &Stream)
#else
CNCSError JP2UserBox::UnParse(class CNCSJP2File &JP2File,
                              CNCSJPCIOStream &Stream)
#endif
{
    CNCSError Error(GetCNCSError(NCS_SUCCESS));

    if (m_nTBox == 0)
    {
        Error = GetCNCSError(NCS_UNKNOWN_ERROR);
        CPLError(CE_Failure, CPLE_AppDefined,
                 "No box type set in JP2UserBox::UnParse()");
        return Error;
    }
#if ECWSDK_VERSION < 50
    Error = CNCSJP2Box::UnParse(JP2File, Stream);
#else
    Error = CNCSSDKBox::UnParse(JP2File, Stream);
#endif

#if ECWSDK_VERSION >= 55
    Stream->Write(pabyData, nDataLength);
#else
    Stream.Write(pabyData, nDataLength);
#endif

    return Error;
}

#endif /* defined(HAVE_COMPRESS) */
