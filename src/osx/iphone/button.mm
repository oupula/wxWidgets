/////////////////////////////////////////////////////////////////////////////
// Name:        src/osx/iphone/button.mm
// Purpose:     wxButton
// Author:      Stefan Csomor
// Modified by:
// Created:     1998-01-01
// RCS-ID:      $Id$
// Copyright:   (c) Stefan Csomor
// Licence:     wxWindows licence
/////////////////////////////////////////////////////////////////////////////

#include "wx/wxprec.h"

#include "wx/button.h"

#ifndef WX_PRECOMP
    #include "wx/panel.h"
    #include "wx/toplevel.h"
    #include "wx/dcclient.h"
#endif

#include "wx/stockitem.h"

#include "wx/osx/private.h"

wxSize wxButton::DoGetBestSize() const
{
    if ( GetId() == wxID_HELP )
        return wxSize( 18 , 18 ) ;

    wxSize sz = GetDefaultSize() ;

    wxRect r ;

    GetPeer()->GetBestRect(&r);

    if ( r.GetWidth() == 0 && r.GetHeight() == 0 )
    {
    }
    sz.x = r.GetWidth();
    sz.y = r.GetHeight();

    int wBtn = 72;

    if ((wBtn > sz.x) || ( GetWindowStyle() & wxBU_EXACTFIT))
        sz.x = wBtn;

    return sz ;
}

wxSize wxButton::GetDefaultSize()
{
    int wBtn = 72 ;
    int hBtn = 35 ;

    return wxSize(wBtn, hBtn);
}

@implementation wxUIButton

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        wxOSXIPhoneClassAddWXMethods( self );
    }
}

- (int)intValue {
    return 0;
}

- (void)setIntValue:(int)v
{
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    // Set title only when rounded rect. / custom
    if (self.buttonType == UIButtonTypeCustom || self.buttonType == UIButtonTypeRoundedRect) {
        [super setTitle:title
               forState:state];
    }

}

@end


void wxWidgetIPhoneImpl::SetDefaultButton( bool isDefault )
{
}

void wxWidgetIPhoneImpl::PerformClick()
{
}


wxWidgetImplType* wxWidgetImpl::CreateButton(wxWindowMac* wxpeer,
                                             wxWindowMac* parent,
                                             wxWindowID id,
                                             const wxString& label,
                                             const wxPoint& pos,
                                             const wxSize& size,
                                             long style,
                                             long extraStyle)
{
    CGRect r = wxOSXGetFrameForControl( wxpeer, pos , size ) ;
    
    // Button type
    UIButtonType buttonType;
    if (style & wxBU_ROUNDED_RECTANGLE) {
        buttonType = UIButtonTypeRoundedRect;
    } else if (style & wxBU_DISCLOSURE) {
        return CreateDisclosureTriangle(wxpeer, parent, id, wxEmptyString, pos, size, style, extraStyle);
    } else if (style & wxBU_INFO_LIGHT) {
        buttonType = UIButtonTypeInfoLight;
    } else if (style & wxBU_INFO_DARK) {
        buttonType = UIButtonTypeInfoDark;
    } else if (style & wxBU_CONTACT_ADD) {
        buttonType = UIButtonTypeContactAdd;
    } else {
        buttonType = UIButtonTypeCustom;
    }
    
    wxUIButton* v = [[wxUIButton buttonWithType:buttonType] retain];
    v.frame = r;
    
    if (buttonType == UIButtonTypeCustom || buttonType == UIButtonTypeRoundedRect) {
        [v setTitle:[NSString stringWithString:wxCFStringRef(label).AsNSString()]
           forState:UIControlStateNormal];
    }
    
    wxWidgetIPhoneImpl* c = new wxWidgetIPhoneImpl( wxpeer, v );
    return c;
}

wxWidgetImplType* wxWidgetImpl::CreateBitmapButton(wxWindowMac* wxpeer,
                                                   wxWindowMac* parent,
                                                   wxWindowID id,
                                                   const wxBitmap& bitmap,
                                                   const wxPoint& pos,
                                                   const wxSize& size,
                                                   long style,
                                                   long extraStyle)
{    
    if (style & wxBU_DISCLOSURE) {
        return CreateDisclosureTriangle(wxpeer, parent, id, wxEmptyString, pos, size, style, extraStyle);
    }

    CGRect r = wxOSXGetFrameForControl( wxpeer, pos , size ) ;
            
    wxUIButton* v = [[wxUIButton buttonWithType:UIButtonTypeCustom] retain];
    v.frame = r;
    [v setImage:[bitmap.GetUIImage() retain]
       forState:UIControlStateNormal];
    wxWidgetIPhoneImpl* c = new wxWidgetIPhoneImpl( wxpeer, v );
    return c;
}

wxWidgetImplType* wxWidgetImpl::CreateDisclosureTriangle(wxWindowMac* wxpeer,
                                                         wxWindowMac* parent,
                                                         wxWindowID WXUNUSED(id),
                                                         const wxString& WXUNUSED(label),
                                                         const wxPoint& pos,
                                                         const wxSize& size,
                                                         long style,
                                                         long WXUNUSED(extraStyle))
{
    CGRect r = wxOSXGetFrameForControl( wxpeer, pos , size ) ;
    wxUIButton* v = [[wxUIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
    [v setFrame:r];
    wxWidgetIPhoneImpl* c = new wxWidgetIPhoneImpl( wxpeer, v );
    return c;
}
