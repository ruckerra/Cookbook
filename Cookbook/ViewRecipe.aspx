<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewRecipe.aspx.cs" Inherits="Cookbook.ViewRecipe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-3" style="width:300px;height:300px;padding:0">
            <div>
                <asp:Image ID="imgRecipe" runat="server" style="vertical-align:middle;border-radius:50%;width:300px;height:300px;position:relative;overflow:hidden;"/>
            </div>
        </div>
        <div class="col-sm-5">
            <asp:Label ID="lblRecipeId" runat="server" Text="" Visible="false"></asp:Label>
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
    <asp:Panel ID="pnlNutritionInfo" runat="server" Visible="false">
        <div class="row">
            <div class="col-md-3">
                <asp:Label ID="lblCalories" runat="server">Calories: </asp:Label>
            </div>
            <div class="col-md-2">
                <asp:Label ID="lblFat" runat="server">Fat: </asp:Label>
            </div>
            <div class="col-md-2">
                <asp:Label ID="lblCarbs" runat="server">Carbs: </asp:Label>
            </div>
            <div class="col-md-2">
                <asp:Label ID="lblFiber" runat="server">Fiber: </asp:Label>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblProtein" runat="server">Protein: </asp:Label>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <asp:Label ID="lblServings" runat="server">Servings: </asp:Label>
            </div>
            <div class="col-md-12">
                <asp:Label ID="lblNutritionNotes" runat="server">Notes: </asp:Label>
            </div>
        </div>
    </asp:Panel>
    <div class="row">
        <div class="col-sm-6">
            <asp:Button ID="btnShowNutrition" runat="server" Text="Show Nutrition Info" CssClass="btn btn-primary btn-frost btn-oline-primary" Visible="false" OnClick="btnShowNutrition_Click" />
            <asp:Button ID="btnReturn" runat="server" Text="Go Back" CssClass="btn btn-primary btn-frost btn-oline-primary" OnClick="btnReturn_Click" />
        </div>
    </div>
</asp:Content>
