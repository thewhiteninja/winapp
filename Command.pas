unit Command;

interface

uses XMLIntf;

type
  TCommand = class
  private
  public
    name: string;
    argument: string;
    param: string;
    nameInAddRemoveSoftware: string;
    visible: boolean;
    constructor Create(node: IXMLNode);
    destructor Destroy; override;
  end;

implementation

uses StrUtils;

constructor TCommand.Create(node: IXMLNode);
var
  tmp: IXMLNode;
begin
  visible := true;
  param := '';
  nameInAddRemoveSoftware := '';

  name := node.NodeName;
  argument := node.Text;

  tmp := node.AttributeNodes.FindNode('param');
  if (tmp <> nil) then
    param := tmp.NodeValue;

  tmp := node.AttributeNodes.FindNode('visible');
  if (tmp <> nil) then
    visible := tmp.NodeValue = 'true';

  tmp := node.AttributeNodes.FindNode('nameInAddRemoveSoftware');
  if (tmp <> nil) then
    nameInAddRemoveSoftware := tmp.NodeValue;
end;

destructor TCommand.Destroy;
begin

end;

end.
