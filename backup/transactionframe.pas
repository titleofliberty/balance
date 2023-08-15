unit transactionframe;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TfraTransaction }

  TfraTransaction = class(TFrame)
    imgDelete: TImage;
    lblTop: TLabel;
    lblBottom: TLabel;
    pnlTransaction: TPanel;
    procedure pnlTransactionResize(Sender: TObject);
  private

  public

  end;

implementation

{$R *.lfm}

{ TfraTransaction }

procedure TfraTransaction.pnlTransactionResize(Sender: TObject);
begin
  lblTop.Height := pnlTransaction.Height div 2;
end;

end.

