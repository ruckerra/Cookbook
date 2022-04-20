<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Cookbook.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <br/>
    <asp:Panel ID="PnlLogin" runat="server">
            <div class="row">
                <div class="col-md-4"></div>
                <div id="LoginInput" class="col-md-4">
                    <h2>Log In</h2>
                    <div class="input-group" style="margin-bottom:1rem">
                        <asp:Label ID="reject" runat="server" Text="Your account is not recognized and cannot login at this time." ForeColor="Red" Visible="false" style="display:block"></asp:Label>
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="TxtbxIdentifier" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Login"></asp:RequiredFieldValidator>
                        <asp:TextBox ID="TxtbxIdentifier" runat="server" style="margin-bottom:1rem" placeholder="Username or Email" CssClass="form-control"></asp:TextBox>
                        <br />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="TxtbxPassword" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Login"></asp:RequiredFieldValidator>
                        <asp:TextBox ID="TxtbxPassword" runat="server" type="Password" placeholder="Password" CssClass="form-control" style="margin-bottom:1rem"></asp:TextBox>
                        <br />
                        <div style="display:inline-block">&nbsp</div>
                        <asp:Button ID="BtnSubmit" runat="server" style="margin-bottom:1rem" Text="Log In" CssClass="btn btn-primary btn-block" class="form-control" ValidationGroup="Login" OnClick="BtnSubmit_Click"/>
                        <a>
                            <asp:Button ID="BtnRegister" runat="server" style="margin-bottom:1rem" Text="Create an Account" CssClass="btn btn-secondary btn-block" class="form-control" OnClick="BtnRegister_Click"/>
                        </a>
                    </div>
                    <div class="col-md-4"></div>
                </div>
            </div>
    </asp:Panel>
    <br/>
</asp:Content>
