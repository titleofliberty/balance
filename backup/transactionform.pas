unit transactionform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls;

type

  { TfrmTransaction }

  TfrmTransaction = class(TForm)
    lblTitle: TLabel;
    lblAmount: TLabel;
    lblCategory: TLabel;
    pnlClient: TPanel;
    pnlRight: TPanel;
    btnDelete: TSpeedButton;
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
  private

  public

  end;

var
  frmTransaction: TfrmTransaction;

implementation

{$R *.lfm}

{ TfrmTransaction }

procedure TfrmTransaction.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Style := bsClear;
  //Canvas.Rectangle(0, 0, Width - 1, Height - 1);
  Canvas.RoundRect(0, 0, Width - 1, Height - 1, 8, 8);
end;

procedure TfrmTransaction.FormResize(Sender: TObject);
begin
  lblTitle.Height := pnlClient.Height div 2;
end;

procedure TfrmTransaction.pnlRightResize(Sender: TObject);
begin
  btnDelete.Top  := (pnlRight.Height - btnDelete.Height) div 2;
end;

end.

