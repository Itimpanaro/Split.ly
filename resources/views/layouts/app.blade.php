<!DOCTYPE html>
<html lang="en">
<head>
    @include('layouts.head')
</head>
<body class="bg-[#E8CCAD]">

    @include('components.navbar')

    <div class="container mx-auto mt-4">
        @yield('content')
    </div>    
</body>
</html>