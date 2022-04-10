<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterAccount.aspx.cs" Inherits="Cookbook.RegisterAccount" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="PnlRegister" runat="server">
        <div class="row">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <h2>Create an Account</h2>
                <div class="input-group">
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="TxtbxRegUsername" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="TxtbxRegUsername" runat="server" placeholder="Username*" CssClass="form-control" style="display:block"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="TxtbxRegEmail" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="TxtbxRegEmail" runat="server" placeholder="Email*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvEmailCheck" runat="server" ControlToValidate="TxtbxEmailCheck" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="TxtbxEmailCheck" runat="server" placeholder="Repeat Email*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="TxtbxRegPassword" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="TxtbxRegPassword" runat="server" type="Password" placeholder="Password*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvPasswordCheck" runat="server" ControlToValidate="TxtbxPasswordCheck" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="TxtbxPasswordCheck" runat="server" placeholder="Repeat Password*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <div style="display:inline-block">&nbsp</div>
                    <asp:Button ID="BtnCreateAccount" runat="server" Text="Create Account" CssClass="btn btn-primary btn-block" style="margin-bottom:1rem" Enabled="False" OnClick="BtnCreateAccount_Click"/>
                    <a>
                        <asp:Button ID="BtnLogin" runat="server" Text="Log in Instead" CssClass="btn btn-secondary btn-block" OnClick="BtnLogin_Click"/>
                    </a>
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>

    </asp:Panel>
</asp:Content>
