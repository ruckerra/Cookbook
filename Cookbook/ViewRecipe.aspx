<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewRecipe.aspx.cs" Inherits="Cookbook.ViewRecipe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-3">
            <asp:Image ID="imgRecipe" runat="server" style="vertical-align:middle;border-radius:50%;width:300px;height:300px;position:relative;overflow:hidden;margin-left:-25%"/>
        </div>
        <div class="col-sm-5">
            <asp:Label ID="lblRecipeName" runat="server">Recipe Name: </asp:Label><br />
            <asp:Label ID="lblPrepTime" runat="server">Prep Time: </asp:Label><br />
            <asp:Label ID="lblTotalTime" runat="server">Total Time: </asp:Label><br />
            <asp:Label ID="lblVegetarian" runat="server">Vegetarian: </asp:Label><br />
            <asp:Label ID="lblGlutenFree" runat="server">Gluten Free: </asp:Label><br />
            <asp:Label ID="lblDenomination" runat="server">Type of Recipe: </asp:Label><br />
            <asp:Label ID="lblNotes" runat="server">Notes: </asp:Label><br />
            <asp:Label ID="lblIngredients" runat="server">Ingredients: </asp:Label><br />
            <asp:Label ID="lblDirections" runat="server">Directions: </asp:Label><br />
        </div>
    </div>
    <div class="row">
        <div class="col-sm-3">
            <asp:Button ID="btnReturn" runat="server" Text="Go Back" CssClass="btn btn-primary" />
        </div>
    </div>
</asp:Content>
