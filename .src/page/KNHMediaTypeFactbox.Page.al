namespace KNHMediaType;
using System.Device;
using System.Environment;

page 53901 "KNH Media Type Factbox"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "KNH Media Type";
    layout
    {
        area(Content)
        {
            field(Media; Rec.Media)
            {
                ToolTip = 'Specifies the value of the Media field.', Comment = '%';
            }
            field(MediaSet; Rec.MediaSet)
            {
                ToolTip = 'Specifies the value of the MediaSet field.', Comment = '%';
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                ToolTip = 'Activate the camera on the device.';
                Visible = this.CameraAvailable and (this.HideActions = false);

                trigger OnAction()
                begin
                    this.TakeNewPicture();
                end;
            }
            action(ImportMedia)
            {
                ApplicationArea = All;
                Caption = 'Import Media';
                Image = Import;
                ToolTip = 'Import media from a file.';

                trigger OnAction()
                var
                    FromFileName: Text;
                    InStreamPic: InStream;
                begin
                    if UploadIntoStream(FromFileName, InStreamPic) then begin
                        Rec.Media.ImportStream(InStreamPic, FromFileName);
                        Rec.Modify(true)
                    end;
                end;
            }
            action(ExportMedia)
            {
                ApplicationArea = All;
                Caption = 'Export Media';
                Image = Export;
                ToolTip = 'Export media to a file.';

                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                    InStreamPic: InStream;
                    ImageLbl: Label '%1_Image.jpg', Comment = '%1 Image file name format';
                    Filename: Text;
                begin
                    if TenantMedia.Get(Rec.Media.MediaId) then begin
                        tenantMedia.CalcFields(Content);
                        if tenantmedia.Content.HasValue then begin
                            Filename := StrSubstNo(ImageLbl, Rec.TableCaption);
                            TenantMedia.Content.CreateInStream(InStreamPic);
                            DownloadFromStream(InStreamPic, '', '', '', Filename)
                        end
                    end
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = this.DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';
                Visible = this.HideActions = false;

                trigger OnAction()
                begin
                    this.DeleteItemPicture();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        this.SetEditableOnPictureActions();
    end;

    trigger OnOpenPage()
    begin
        this.CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Codeunit Camera;
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        DeleteExportEnabled: Boolean;
        HideActions: Boolean;
        MimeTypeTok: Label 'image/jpeg', Locked = true;

    procedure TakeNewPicture()
    begin
        Rec.Find();
        Rec.TestField(Code);

        this.OnAfterTakeNewPicture(Rec, this.DoTakeNewPicture());
    end;

    local procedure DoTakeNewPicture(): Boolean
    var
        PictureInstream: InStream;
        PictureDescription: Text;
    begin
        if Rec.Code <> '' then
            if not Confirm(this.OverrideImageQst) then
                exit(false);

        if this.Camera.GetPicture(PictureInstream, PictureDescription) then begin
            Clear(Rec.media);
            Rec.media.ImportStream(PictureInstream, PictureDescription, this.MimeTypeTok);
            Rec.Modify(true);
            exit(true);
        end;

        exit(false);
    end;

    local procedure SetEditableOnPictureActions()
    begin
        this.DeleteExportEnabled := Rec.Code <> '';
    end;

    procedure IsCameraAvailable(): Boolean
    begin
        exit(this.Camera.IsAvailable());
    end;

    procedure SetHideActions()
    begin
        this.HideActions := true;
    end;

    procedure DeleteItemPicture()
    begin
        Rec.TestField(Code);
        if not Confirm(this.DeleteImageQst) then
            exit;

        Clear(Rec.Media);
        Rec.Modify(true);

        this.OnAfterDeleteItemPicture(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteItemPicture(var Picture: Record "KNH Media Type")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTakeNewPicture(var Picture: Record "KNH Media Type"; IsPictureAdded: Boolean)
    begin
    end;
}