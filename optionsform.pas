unit optionsform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmOptions }

  TfrmOptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    txtDescriptions: TMemo;
    txtCategorys: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.lfm}

{ TfrmOptions }

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  txtDescriptions.Lines.LoadFromFile('descriptions.txt');
  txtCategorys.Lines.LoadFromFile('categories.txt');
end;

end.

