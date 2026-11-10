/// <summary>
/// MediaTable
/// </summary>
namespace KNHMediaType;

table 53900 "KNH Media Type"
{
    Caption = 'MediaTable';
    DataClassification = CustomerContent;
    AllowInCustomizations = AsReadOnly;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Media; Media)
        {
            DataClassification = CustomerContent;
        }
        field(3; MediaSet; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(4; Blob; Blob)
        {
            DataClassification = CustomerContent;
            Subtype = bitmap;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
