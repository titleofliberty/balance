unit transactionform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Calendar,
  Spin;

type

  { TfrmTransaction }

  TfrmTransaction = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    calDate: TCalendar;
    chkIncome: TCheckBox;
    chkCleared: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    txtAmount: TFloatSpinEdit;
    txtCategory: TComboBox;
    txtDescription: TComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmTransaction: TfrmTransaction;

implementation

{$R *.lfm}

{ TfrmTransaction }

procedure TfrmTransaction.FormCreate(Sender: TObject);
begin
  txtDescription.Items.LoadFromFile('descriptions.txt');
  txtCategory.Items.LoadFromFile('categories.txt');
end;

procedure TfrmTransaction.btnSaveClick(Sender: TObject);
var
  desc, cat: string;
begin
  if txtDescription.ItemIndex = -1 then
  begin
    desc := Trim(txtDescription.Text);
    txtDescription.Items.Add(desc);
    txtDescription.Items.SaveToFile('descriptions.txt');
  end;
  if txtCategory.ItemIndex = -1 then
  begin
    cat := Trim(txtCategory.Text);
    txtCategory.Items.Add(cat);
    txtCategory.Items.SaveToFile('categories.txt');
  end;
end;

end.

