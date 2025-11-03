import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:petshop_template/src/carrinho/view/page_carrinho.dart';
import 'package:petshop_template/src/carrinho/view/page_entrega.dart';
import 'package:petshop_template/src/carrinho/view/page_pagamento.dart';
import 'package:petshop_template/src/cliente/view/page_clientes.dart';
import 'package:petshop_template/src/comissao/view/page_comissoa.dart';
import 'package:petshop_template/src/home.dart';
import 'package:petshop_template/src/login/view/page_alterar_senha.dart';
import 'package:petshop_template/src/login/view/page_cadastro.dart';
import 'package:petshop_template/src/login/view/page_codigo_recuperacao.dart';
import 'package:petshop_template/src/login/view/page_login.dart';
import 'package:petshop_template/src/login/view/page_recuperar_senha.dart';
import 'package:petshop_template/src/menu/view/page_menu.dart';
import 'package:petshop_template/src/pedidos/view/page_pedido_detalhes.dart';
import 'package:petshop_template/src/pets/view/page_pets.dart';
import 'package:petshop_template/src/produtos/view/page_categorias.dart';
import 'package:petshop_template/src/produtos/view/page_categorias_sub.dart';
import 'package:petshop_template/src/produtos/view/page_produto_detalhes.dart';
import 'package:petshop_template/src/produtos/view/page_produtos_pesquisar.dart';
import 'package:petshop_template/src/produtos/view/page_produtos_resultado_pesquisa.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      page: () => const PageProdutoDetalhes(),
      name: PageRoutes.produtosDetails,
    ),
    GetPage(
      page: () => const PageClientes(),
      name: PageRoutes.clientesPesquisar,
    ),
    GetPage(
      page: () => const PageProdutosResultadoPesquisa(),
      name: PageRoutes.produtosCategoriasPesquisar,
    ),
    GetPage(
      page: () => const PageCategorias(),
      name: PageRoutes.categoriasPesquisar,
    ),
    GetPage(
      page: () => const PageCategoriasSub(),
      name: PageRoutes.pageCategoriasSub,
    ),
    GetPage(
      page: () => const PagePesquisarProdutos(),
      name: PageRoutes.produtosPesquisar,
    ),
    GetPage(
      page: () => const LoginPage(),
      name: PageRoutes.login,
    ),
    GetPage(
      page: () => const HomePage(),
      name: PageRoutes.baseRoute,
    ),
    GetPage(
      page: () => const PagePedidoDetalhe(),
      name: PageRoutes.pagePedidosDetalhe,
    ),
    GetPage(
      page: () => const PageCarrinho(),
      name: PageRoutes.carrinho,
    ),
    GetPage(
      page: () => const PageComissao(),
      name: PageRoutes.comissao,
    ),
    GetPage(
      page: () => const PageCadastro(),
      name: PageRoutes.pageCadastro,
    ),
    GetPage(
      page: () => const MenuPage(),
      name: PageRoutes.pageMenu,
    ),
    GetPage(
      page: () => const PageAlterarSenha(),
      name: PageRoutes.pageAlterarSenha,
    ),
    GetPage(
      page: () => const PageRecuperarSenha(),
      name: PageRoutes.pageRecuperacaoSenha,
    ),
    GetPage(
      page: () => const PageCodigoRecuperacao(),
      name: PageRoutes.pageCodigoRecuperacaoState,
    ),
    GetPage(
      page: () => const PageEntrega(),
      name: PageRoutes.pageCarrinhoEntrega,
    ),
    GetPage(
      page: () => const PageFormaPagamento(),
      name: PageRoutes.pageCarrinhoPagamento,
    ),
    GetPage(
      page: () => const PagePets(),
      name: PageRoutes.pagePets,
    ),
  ];
}

abstract class PageRoutes {
  static const produtosDetails = '/produtosDetails';
  static const produtosCategoriasPesquisar = '/produtosCategoriasPesquisar';
  static const categoriasPesquisar = '/categoriasPesquisar';
  static const pageCategoriasSub = '/categoriasSub';
  static const produtosPesquisar = '/produtosPesquisar';
  static const clientesPesquisar = '/clientesPesquisar';
  static const login = '/login';
  static const pagePedidosDetalhe = '/pedidosDetalhe';
  static const baseRoute = '/home';
  static const carrinho = '/carrinho';
  static const comissao = '/comissao';
  static const pageCadastro = '/cadastro';
  static const pageMenu = '/menu';
  static const pageAlterarSenha = '/alterarSenha';
  static const pageRecuperacaoSenha = '/recuperacaoSenha';
  static const pageCodigoRecuperacaoState = '/PageCodigoRecuperacaoState';
  static const pageCarrinhoEntrega = '/PageCarrinhoEntrega';
  static const pageCarrinhoPagamento = '/PageCarrinhoPagamento';
  static const pagePets = '/pagePets';
}
