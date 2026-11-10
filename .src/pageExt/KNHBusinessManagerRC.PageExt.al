namespace KNHMediaType;
using Microsoft.Finance.RoleCenters;

pageextension 53900 "KNH Business Manager RC" extends "Business Manager Role Center"
{
    actions
    {
        addafter(Reports)
        {
            action("KNH_Media Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies various media types for use in the system.';
                Caption = 'Media Type Fields';
                RunObject = page "KNH Media Type";
            }
        }
    }
}